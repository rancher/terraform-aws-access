locals {

  use     = var.use
  content = lower(var.content)
  ip      = var.ip

  content_parts = split(".", local.content)
  top_level_domain = join(".", [
    local.content_parts[(length(local.content_parts) - 2)],
    local.content_parts[(length(local.content_parts) - 1)],
  ])
  subdomain = local.content_parts[0]
  found_zone = join(".", [
    for part in local.content_parts : part if part != local.subdomain
  ])

  # zone
  zone_id       = (local.zone_select == 1 ? data.aws_route53_zone.select[0].id : aws_route53_zone.new[0].id)
  domain_zone   = var.zone
  zone          = (local.domain_zone == "" ? local.found_zone : local.domain_zone)
  zone_create   = (local.domain_zone == "" ? 0 : 1)
  zone_select   = (local.domain_zone == "" ? 1 : 0)
  zone_resource = (local.zone_create == 1 ? aws_route53_zone.new[0] : data.aws_route53_zone.select[0])

  # domain record
  create = (local.use == "create" ? 1 : 0)
  select = (local.use == "select" ? 1 : 0)
}

data "aws_route53_zone" "select" {
  count = local.zone_select
  name  = local.zone
}
resource "aws_route53_zone" "new" {
  count = local.zone_create
  name  = local.zone
}
resource "aws_route53_record" "ns" {
  count           = local.zone_create
  allow_overwrite = true
  name            = local.zone
  ttl             = 300
  type            = "NS"
  zone_id         = aws_route53_zone.new[0].zone_id

  records = [
    aws_route53_zone.new[0].name_servers[0],
    aws_route53_zone.new[0].name_servers[1],
    aws_route53_zone.new[0].name_servers[2],
    aws_route53_zone.new[0].name_servers[3],
  ]
}

resource "aws_route53domains_registered_domain" "select" {
  count       = local.select
  domain_name = local.content
}

resource "aws_route53_record" "new" {
  depends_on = [
    data.aws_route53_zone.select,
    aws_route53_zone.new,
  ]
  count   = local.create
  zone_id = local.zone_id
  name    = local.content
  type    = "A"
  ttl     = 30
  records = [local.ip]
}

resource "tls_private_key" "private_key" {
  count     = local.create
  algorithm = "RSA"
}

# Warning, this can lead to rate limiting if you are not careful
# make sure you are not creating a new acme_registration for every certificate
resource "acme_registration" "reg" {
  count           = local.create
  account_key_pem = tls_private_key.private_key[0].private_key_pem
  email_address   = "${local.zone_id}@${local.top_level_domain}"
}

resource "tls_private_key" "cert_private_key" {
  count     = local.create
  algorithm = "RSA"
}
resource "tls_cert_request" "req" {
  count           = local.create
  private_key_pem = tls_private_key.cert_private_key[0].private_key_pem
  subject {
    common_name = local.content
  }
}

resource "acme_certificate" "new" {
  depends_on = [
    data.aws_route53_zone.select,
    aws_route53_zone.new,
    aws_route53_record.new,
    acme_registration.reg,
    tls_private_key.private_key,
    tls_private_key.cert_private_key,
    tls_cert_request.req,
  ]
  count                   = local.create
  account_key_pem         = acme_registration.reg[0].account_key_pem
  certificate_request_pem = tls_cert_request.req[0].cert_request_pem
  recursive_nameservers = [
    "${local.zone_resource.primary_name_server}:53",
  ]
  disable_complete_propagation = true
  dns_challenge {
    provider = "route53"
    config = {
      AWS_PROPAGATION_TIMEOUT = 2400,
      AWS_POLLING_INTERVAL    = 60,
      AWS_HOSTED_ZONE_ID      = local.zone_id,
    }
  }
}

resource "aws_iam_server_certificate" "new" {
  depends_on = [
    data.aws_route53_zone.select,
    aws_route53_zone.new,
    aws_route53_record.new,
    acme_registration.reg,
    tls_private_key.private_key,
    tls_private_key.cert_private_key,
    tls_cert_request.req,
    acme_certificate.new,
  ]
  count            = local.create
  name_prefix      = local.content
  certificate_body = acme_certificate.new[0].certificate_pem
  private_key      = tls_private_key.cert_private_key[0].private_key_pem
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_server_certificate" "select" {
  depends_on = [
    data.aws_route53_zone.select,
    aws_route53_zone.new,
    aws_route53_record.new,
    acme_registration.reg,
    tls_private_key.private_key,
    tls_private_key.cert_private_key,
    tls_cert_request.req,
    acme_certificate.new,

  ]
  count       = local.select
  name_prefix = local.content
  latest      = true
}
