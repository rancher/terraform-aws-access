locals {
  owner = var.owner

  content    = var.content                           # the domain to register eg. "blah.blah.test.example.com"
  alias      = var.alias                             # optional pre-generated domain name eg. "mylb.region.elb.amazonaws.com"
  content_id = "${local.zone_id}_${local.content}_A" # used in output

  add_zone    = (var.zone == "" ? 0 : 1) # add a zone if given a zone, else select a zone
  select_zone = (local.add_zone == 1 ? 0 : 1) # select is the opposite of add

  zone_id     = (local.add_zone == 1 ? resource.aws_route53_zone.new[0].id : data.aws_route53_zone.select[0].id)
  domain_part_count = length(split(".", local.content))
  domain_parts = split(".", local.content)
  top_level_domain = local.domain_parts[(local.domain_part_count - 1)]
  next_level_domain = local.domain_parts[(local.domain_part_count - 2)]
  find_zone   = join(".", [local.next_level_domain, local.top_level_domain]) # extract the zone from the domain eg. "example.com"
  zone        = (var.zone == "" ? local.find_zone : var.zone)

  create = (var.create ? 1 : 0) # create is always an alias because it can only attached to a load balancer at this point in the project
  select = (local.create == 1 ? 0 : 1)   # select is the opposite of create

  validation_records = [
    for option in aws_acm_certificate.new[0].domain_validation_options : {
      name    = option.resource_record_name
      record  = option.resource_record_value
      type    = option.resource_record_type
      zone_id = local.zone_id
    }
  ]
  # Transform the list of maps into a map using the 'name' and 'type' as the key
  validation_records_map = { for record in local.validation_records : "${record.name}_${record.type}" => record }


}

data "aws_route53_zone" "select" {
  count = local.select_zone
  name  = local.find_zone
  tags = {
    Name = local.find_zone
  }
}

resource "aws_route53_zone" "new" {
  count = local.add_zone
  name  = local.zone
  tags = {
    Name  = local.zone
    Owner = local.owner
  }
}

resource "aws_route53domains_registered_domain" "select" {
  count = local.select
  domain_name = local.content
}

# alias is a pre-generated "aws" domain eg. mylb.region.elb.amazonaws.com
# this cnames the pre-generated aws domain to the specified domain
resource "aws_route53_record" "new" {
  depends_on = [
    aws_route53_zone.new,
    data.aws_route53_zone.select,
  ]
  count   = local.create
  zone_id = local.zone_id
  name    = local.content
  type    = "CNAME"
  records = [local.alias]
  ttl     = 60
}

# only generate a certificate if the domain is not already registered
resource "aws_acm_certificate" "new" {
  depends_on = [
    aws_route53_zone.new,
    data.aws_route53_zone.select,
    aws_route53_record.new,
  ]
  count             = local.create
  domain_name       = local.content
  validation_method = "DNS"
  tags = {
    Name  = local.content
    Owner = local.owner
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  depends_on = [
    aws_route53_zone.new,
    data.aws_route53_zone.select,
    aws_route53_record.new,
    aws_acm_certificate.new,
  ]
  count   = local.create
  zone_id = local.zone_id
  name    = tolist(aws_acm_certificate.new[0].domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.new[0].domain_validation_options)[0].resource_record_type
  records = [tolist(aws_acm_certificate.new[0].domain_validation_options)[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "certificate_validation" {
  depends_on = [
    aws_route53_zone.new,
    data.aws_route53_zone.select,
    aws_route53_record.new,
    aws_acm_certificate.new,
    aws_route53_record.cert_validation,
  ]
  count                   = local.create
  certificate_arn         = aws_acm_certificate.new[0].arn
  validation_record_fqdns = [aws_route53_record.cert_validation[0].fqdn]
}
