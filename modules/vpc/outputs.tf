output "id" {
  value = (local.select == 1 ? data.aws_vpc.selected[0].id : aws_vpc.new[0].id)
}
output "vpc" {
  value = (local.select == 1 ? data.aws_vpc.selected[0] : aws_vpc.new[0])
}