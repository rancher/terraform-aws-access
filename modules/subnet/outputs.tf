output "name" {
  value = local.name
}
output "type" {
  value = local.type
}
output "id" {
  value = (
    local.select == 1 ?
    data.aws_subnet.selected[0].id :
    can(aws_subnet.created[0].id) ?
    aws_subnet.created[0].id :
    ""
  )
}
output "arn" {
  value = (
    local.select == 1 ?
    data.aws_subnet.selected[0].arn :
    can(aws_subnet.created[0].arn) ?
    aws_subnet.created[0].arn :
    ""
  )
}
output "availability_zone" {
  value = (
    local.select == 1 ?
    data.aws_subnet.selected[0].availability_zone :
    can(aws_subnet.created[0].availability_zone) ?
    aws_subnet.created[0].availability_zone :
    ""
  )
}
output "availability_zone_id" {
  value = (
    local.select == 1 ?
    data.aws_subnet.selected[0].availability_zone_id :
    can(aws_subnet.created[0].availability_zone_id) ?
    aws_subnet.created[0].availability_zone_id :
    ""
  )
}
output "tags" {
  value = (
    local.select == 1 ?
    data.aws_subnet.selected[0].tags :
    can(aws_subnet.created[0].tags) ?
    aws_subnet.created[0].tags :
    tomap({ "" = "" })
  )
}
output "cidrs" {
  value = (
    local.select == 1 ? {
      ipv4 = data.aws_subnet.selected[0].cidr_block
      ipv6 = data.aws_subnet.selected[0].ipv6_cidr_block
    } :
    local.create == 1 ? {
      ipv4 = aws_subnet.created[0].cidr_block
      ipv6 = aws_subnet.created[0].ipv6_cidr_block
    } :
    {
      ipv4 = ""
      ipv6 = ""
    }
  )
}
