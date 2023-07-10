output "id" {
  value = (local.select == 1 ? data.aws_subnet.selected[0].id : aws_subnet.new[0].id)
}
output "cidr" {
  value = (local.select == 1 ? data.aws_subnet.selected[0].cidr_block : aws_subnet.new[0].cidr_block)
}
output "subnet" {
  value = (local.select == 1 ? data.aws_subnet.selected[0] : aws_subnet.new[0])
}