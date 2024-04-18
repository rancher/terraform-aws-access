output "id" {
  value = (local.select == 1 ? data.aws_lb.selected[0].id : aws_lb.new[0].id)
}
output "dns_name" {
  value = (local.select == 1 ? data.aws_lb.selected[0].dns_name : aws_lb.new[0].dns_name)
}
output "load_balancer" {
  value = (local.select == 1 ? data.aws_lb.selected[0] : aws_lb.new[0])
}
output "public_ip" {
  value = local.public_ip
}
output "listeners" {
  value = (local.create == 1 ? aws_lb_listener.created : {})
}
output "target_groups" {
  value = aws_lb_target_group.created
}