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
  value = (local.select == 1 ? data.aws_iam_server_certificate.select[0] : aws_iam_server_certificate.new[0])
}
output "certificate_arn" {
  value = (local.select == 1 ? data.aws_iam_server_certificate.select[0].arn : aws_iam_server_certificate.new[0].arn)
}
