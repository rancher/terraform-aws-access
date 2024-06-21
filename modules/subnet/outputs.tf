output "id" {
  value = (
    local.select == 1 ? data.aws_subnet.selected[0].id :
    local.ipv4 == 1 ? aws_subnet.ipv4[0].id : can(aws_subnet.ipv6[0].id) ? aws_subnet.ipv6[0].id : ""
  )
}
output "arn" {
  value = (
    local.select == 1 ? data.aws_subnet.selected[0].arn :
    local.ipv4 == 1 ? aws_subnet.ipv4[0].arn : can(aws_subnet.ipv6[0].arn) ? aws_subnet.ipv6[0].arn : ""
  )
}
output "name" {
  value = local.name
}
output "type" {
  value = local.type
}
output "availability_zone" {
  value = (
    local.select == 1 ? data.aws_subnet.selected[0].availability_zone :
    local.ipv4 == 1 ? aws_subnet.ipv4[0].availability_zone : can(aws_subnet.ipv6[0].availability_zone) ? aws_subnet.ipv6[0].availability_zone : ""
  )
}
output "availability_zone_id" {
  value = (
    local.select == 1 ? data.aws_subnet.selected[0].availability_zone_id :
    local.ipv4 == 1 ? aws_subnet.ipv4[0].availability_zone_id : can(aws_subnet.ipv6[0].availability_zone_id) ? aws_subnet.ipv6[0].availability_zone_id : ""
  )
}
output "cidrs" {
  value = (
    local.select == 1 ? {
      ipv4 = (can(data.aws_subnet.selected[0].cidr_block) ? data.aws_subnet.selected[0].cidr_block : ""),
      ipv6 = (can(data.aws_subnet.selected[0].ipv6_cidr_block) ? data.aws_subnet.selected[0].ipv6_cidr_block : "")
    } :
    local.create == 1 ? {
      ipv4 = (can(aws_subnet.ipv4[0].cidr_block) ? aws_subnet.ipv4[0].cidr_block : ""),
      ipv6 = (can(aws_subnet.ipv6[0].ipv6_cidr_block) ? aws_subnet.ipv6[0].ipv6_cidr_block : "")
    } :
    {} # default
  )
}
output "tags" {
  value = (
    local.select == 1 ? data.aws_subnet.selected[0].tags :
    local.ipv4 == 1 ? aws_subnet.ipv4[0].tags : can(aws_subnet.ipv6[0].tags) ? aws_subnet.ipv6[0].tags : tomap({ "" = "" })
  )
}
