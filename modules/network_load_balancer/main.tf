locals {
  use               = var.use
  name              = var.name
  vpc_id            = var.vpc_id
  security_group_id = var.security_group_id
  subnets           = var.subnets
  access_info       = (var.access_info == null ? {} : var.access_info)
  create            = (local.use == "create" ? 1 : 0)
  select            = (local.use == "select" ? 1 : 0)
  eips              = (local.select == 1 ? data.aws_eip.selected : aws_eip.created)
  public_ips        = (local.select == 1 ? [for e in data.aws_eip.selected : e.public_ip if can(e.public_ip)] : [for e in aws_eip.created : e.public_ip if can(e.public_ip)])
}

data "aws_lb" "selected" {
  count = local.select
  tags = {
    Name = local.name
  }
}

data "aws_eip" "selected" {
  for_each = (local.select == 1 ? local.subnets : {})
  filter {
    name   = "name"
    values = [local.name]
  }
}

resource "aws_eip" "created" {
  for_each                  = (local.create == 1 ? local.subnets : {})
  domain                    = "vpc"
  associate_with_private_ip = cidrhost(each.value.cidr, -2) # map the eip to the last available ip of the private subnet
  tags = {
    Name = local.name
  }
}

resource "aws_security_group" "load_balancer" {
  count       = local.create
  name        = local.name
  description = "Security group for load balancer ${local.name}"
  vpc_id      = local.vpc_id
  tags = {
    Name = local.name
  }
}

resource "aws_security_group_rule" "external_ingress" {
  for_each          = (local.create == 1 ? local.access_info : {})
  security_group_id = aws_security_group.load_balancer[0].id
  type              = "ingress"
  from_port         = each.value.port
  to_port           = each.value.port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidrs
}

resource "aws_lb" "new" {
  count                            = local.create
  name                             = local.name
  internal                         = false
  load_balancer_type               = "network"
  security_groups                  = [local.security_group_id]
  enable_cross_zone_load_balancing = true
  dynamic "subnet_mapping" {
    for_each = local.subnets
    content {
      subnet_id     = subnet_mapping.value.id
      allocation_id = local.eips[subnet_mapping.key].id
    }
  }
  tags = {
    Name = local.name
  }
}

resource "aws_lb_target_group" "created" {
  for_each    = (local.create == 1 ? local.access_info : {})
  name_prefix = "${substr(md5("${local.name}-${each.key}"), 0, 5)}-"
  port        = each.value.port
  protocol    = upper(each.value.protocol)
  vpc_id      = local.vpc_id
  tags = {
    Name = "${local.name}-${each.key}"
  }
}

resource "aws_lb_listener" "created" {
  for_each          = (local.create == 1 ? local.access_info : {})
  load_balancer_arn = aws_lb.new[0].arn
  port              = each.value.port
  protocol          = upper(each.value.protocol)
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.created[each.key].arn
  }
}
