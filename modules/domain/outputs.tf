output "id" {
  value = (local.select == 1 ? local.content_id : aws_route53_record.new[0].id)
}
output "zone_id" {
  value = (local.select_zone == 1 ? data.aws_route53_zone.select[0].id : aws_route53_zone.new[0].id)
}
output "zone" {
  value = (local.select_zone == 1 ? data.aws_route53_zone.select[0] : aws_route53_zone.new[0])
}
output "domain" {
  value = (local.select == 1 ? aws_route53domains_registered_domain.select[0] : aws_route53_record.new[0])
}
