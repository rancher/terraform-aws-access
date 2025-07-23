output "id" {
  value = (
    local.select == 1 ?
    aws_route53domains_registered_domain.select[0].id :
    local.ipv4ds == 1 ?
    aws_route53_record.ipv4[0].id :
    aws_route53_record.ipv6[0]
  )
}
output "domain" {
  value = (
    local.select == 1 ? aws_route53domains_registered_domain.select[0] :
    local.ipv4ds == 1 ? aws_route53_record.ipv4[0] : aws_route53_record.ipv6[0]
  )
}
output "zone_id" {
  value = local.zone_id
}
output "zone" {
  value = local.zone_resource
}
output "certificate" {
  sensitive = true
  value = (local.cert_use != "skip" ? (local.select_cert == 1 ? {
    # select
    public_key  = data.aws_iam_server_certificate.select[0].certificate_body
    private_key = ""
    chain       = data.aws_iam_server_certificate.select[0].certificate_chain
    } : {
    # create
    public_key  = acme_certificate.new[0].certificate_pem
    private_key = tls_private_key.cert_private_key[0].private_key_pem
    chain       = acme_certificate.new[0].issuer_pem
    }) : {
    # default
    public_key  = ""
    private_key = ""
    chain       = ""
  })
}
output "certificate_arn" {
  value = (local.cert_use != "skip" ? (local.select_cert == 1 ? data.aws_iam_server_certificate.select[0].arn : aws_iam_server_certificate.new[0].arn) : "")
}
