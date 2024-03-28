locals {

  use     = var.use
  content = lower(var.content)
  ip      = var.ip

  content_parts = split(".", local.content)
  top_level_domain = join(".", [
    local.content_parts[(length(local.content_parts) - 2)],
    local.content_parts[(length(local.content_parts) - 1)],
  ])
  zone = join(".", [
    for i in range(1, length(local.content_parts) - 1) : local.content_parts[i]
  ])

  # zone
  zone_id = data.aws_route53_zone.select.id

  # domain record
  create = (local.use == "create" ? 1 : 0)
  select = (local.use == "select" ? 1 : 0)
}

data "aws_route53_zone" "select" {
  name = "${local.zone}."
}

resource "aws_route53domains_registered_domain" "select" {
  count       = local.select
  domain_name = local.content
}

resource "aws_route53_record" "new" {
  depends_on = [
    data.aws_route53_zone.select,
  ]
  count   = local.create
  zone_id = local.zone_id
  name    = local.content
  type    = "A"
  ttl     = 30
  records = [local.ip]
}

resource "terraform_data" "dig_new_record" {
  depends_on = [
    data.aws_route53_zone.select,
    aws_route53_record.new,
  ]
  count = local.create
  triggers_replace = [
    local.content,
    local.create,
  ]
  provisioner "local-exec" {
    command = <<-EOT
      #!/bin/bash

      DOMAIN='${local.content}'
      #DNS_SERVER='${data.aws_route53_zone.select.primary_name_server}'
      DNS_SERVER='8.8.8.8 1.1.1.1'

      # Timeout in seconds (5 minutes)
      TIMEOUT=300

      # Start time
      START_TIME=$(date +%s)

      # Loop until timeout
      while [ $(($(date +%s)-$START_TIME)) -lt $TIMEOUT ]; do
          # Query the domain
          RESULT="$(dig @$DNS_SERVER $DOMAIN +short)"
          
          # Check if the domain is available
          if [ -n "$RESULT" ]; then
              echo "Domain $DOMAIN is available at $DNS_SERVER. IP: $RESULT."
              exit 0
          else
              echo "Domain $DOMAIN is not available yet. Retrying..."
              sleep 30
          fi
      done

      # If the loop ends without finding the domain, it's not available
      echo "Domain $DOMAIN is not available after 5 minutes."
      exit 1
    EOT
  }
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

resource "acme_certificate" "certificate" {
  depends_on = [
    data.aws_route53_zone.select,
    aws_route53_record.new,
    terraform_data.dig_new_record,
    acme_registration.reg,
    tls_private_key.private_key,
    tls_private_key.cert_private_key,
    tls_cert_request.req,
  ]
  account_key_pem         = acme_registration.reg[0].account_key_pem
  certificate_request_pem = tls_cert_request.req[0].cert_request_pem
  pre_check_delay         = 30
  recursive_nameservers = [
    "${data.aws_route53_zone.select.primary_name_server}:53",
    "1.1.1.1",
    "8.8.8.8",
  ]
  disable_complete_propagation = true
  dns_challenge {
    provider = "route53"
    config = {
      AWS_PROPAGATION_TIMEOUT = 60,
      AWS_POLLING_INTERVAL    = 10,
    }
  }
}
resource "terraform_data" "dig_cert_txt" {
  depends_on = [
    data.aws_route53_zone.select,
    aws_route53_record.new,
    terraform_data.dig_new_record,
    acme_registration.reg,
    tls_private_key.private_key,
    tls_private_key.cert_private_key,
    tls_cert_request.req,
    #acme_certificate.certificate, # run at same time as certificate
  ]
  count = local.create
  triggers_replace = [
    local.content,
    local.create,
  ]
  provisioner "local-exec" {
    command = <<-EOT
      #!/bin/bash

      # Domain to query
      DOMAIN='_acme-challenge.${local.content}'
      #DNS_SERVER="${data.aws_route53_zone.select.primary_name_server}"
      DNS_SERVER='1.1.1.1 8.8.8.8'

      # Timeout in seconds (5 minutes)
      TIMEOUT=300

      # Start time
      START_TIME=$(date +%s)

      # Loop until timeout
      while [ $(($(date +%s)-$START_TIME)) -lt $TIMEOUT ]; do
          # Query the domain
          RESULT="$(dig @$DNS_SERVER $DOMAIN TXT +short)"
          
          # Check if the domain is available
          if [ -n "$RESULT" ]; then
              echo "Domain $DOMAIN is available at $DNS_SERVER. TXT record: $RESULT."
              exit 0
          else
              echo "Domain $DOMAIN is not available yet. Retrying..."
              sleep 30
          fi
      done

      # If the loop ends without finding the domain, it's not available
      echo "Domain $DOMAIN is not available after 5 minutes."
      exit 1
    EOT
  }
}
