output "id" {
  value = (local.select == 1 ? data.aws_lb.selected[0].id : aws_lb.new[0].id)
}
output "dns_name" {
  value = (local.select == 1 ? data.aws_lb.selected[0].dns_name : aws_lb.new[0].dns_name)
}
output "load_balancer" {
  value = (local.select == 1 ? data.aws_lb.selected[0] : aws_lb.new[0])
}
output "target_group_names" {
  value = (local.create == 1 ? [
    aws_lb_target_group.port80[0].tags.Name,
    aws_lb_target_group.port443[0].tags.Name,
    aws_lb_target_group.port6443[0].tags.Name,
  ] : [])
}
output "listener_names" {
  value = (local.create  == 1 ? [
    aws_lb_listener.port80[0].tags.Name,
    aws_lb_listener.port443[0].tags.Name,
    aws_lb_listener.port6443[0].tags.Name,
  ] : [])
}
