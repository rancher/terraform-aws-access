output "id" {
  value = (local.select == 1 ? aws_route53domains_registered_domain.select[0].id : aws_route53_record.new[0].id)
}
output "zone_id" {
  value = local.zone_id
}
output "zone" {
  value = local.zone_resource
}
output "domain" {
  value = (local.select == 1 ? aws_route53domains_registered_domain.select[0] : aws_route53_record.new[0])
}
output "certificate" {
  value = (local.cert_use != "skip" ? (local.select_cert == 1 ? {
    id          = data.aws_iam_server_certificate.select[0].id
    arn         = data.aws_iam_server_certificate.select[0].arn
    name        = data.aws_iam_server_certificate.select[0].name
    expiration  = data.aws_iam_server_certificate.select[0].expiration_date
    upload_date = data.aws_iam_server_certificate.select[0].upload_date
    tags_all    = tomap({ "unknown" = "unknown" })
    } : {
    id          = aws_iam_server_certificate.new[0].id
    arn         = aws_iam_server_certificate.new[0].arn
    name        = aws_iam_server_certificate.new[0].name
    expiration  = aws_iam_server_certificate.new[0].expiration
    upload_date = aws_iam_server_certificate.new[0].upload_date
    tags_all    = aws_iam_server_certificate.new[0].tags_all
    }) : {
    id          = ""
    arn         = ""
    name        = ""
    expiration  = ""
    upload_date = ""
    tags_all    = tomap({ "" = "" })
  })
}
output "certificate_arn" {
  value = (local.cert_use != "skip" ? (local.select_cert == 1 ? data.aws_iam_server_certificate.select[0].arn : aws_iam_server_certificate.new[0].arn) : "")
}
