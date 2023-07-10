output "id" {
  value = (local.select == 1 ? data.aws_security_group.selected[0].id : aws_security_group.new[0].id)
}
output "security_group" {
  value = (local.select == 1 ? data.aws_security_group.selected[0] : aws_security_group.new[0])
}