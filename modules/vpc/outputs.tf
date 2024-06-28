output "id" {
  value = (
    local.select == 1 ?
    data.aws_vpc.selected[0].id :
    local.create == 1 ?
    aws_vpc.new[0].id :
    ""
  )
}
output "arn" {
  value = (
    local.select == 1 ?
    data.aws_vpc.selected[0].arn :
    local.create == 1 ?
    aws_vpc.new[0].arn :
    ""
  )
}
output "ipv4" {
  value = (
    local.select == 1 ?
    data.aws_vpc.selected[0].cidr_block :
    local.create == 1 ?
    aws_vpc.new[0].cidr_block :
    ""
  )
}
output "ipv6" {
  value = (
    local.select == 1 ?
    data.aws_vpc.selected[0].ipv6_cidr_block :
    local.create == 1 ?
    aws_vpc.new[0].ipv6_cidr_block :
    ""
  )
}
output "main_route_table_id" {
  value = (
    local.select == 1 ?
    data.aws_vpc.selected[0].main_route_table_id :
    local.create == 1 ?
    aws_vpc.new[0].main_route_table_id :
    ""
  )
}
output "tags" {
  value = (
    local.select == 1 ?
    data.aws_vpc.selected[0].tags :
    local.create == 1 ?
    aws_vpc.new[0].tags :
    tomap({ "" = "" })
  )
}
