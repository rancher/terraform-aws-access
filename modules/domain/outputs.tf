output "id" {
  value = (local.select == 1 ? aws_route53domains_registered_domain.select[0].id : aws_route53_record.new[0].id)
}
output "zone_id" {
  value = data.aws_route53_zone.select.id
}
output "zone" {
  value = data.aws_route53_zone.select
}
output "domain" {
  value = (local.select == 1 ? aws_route53domains_registered_domain.select[0] : aws_route53_record.new[0])
}
