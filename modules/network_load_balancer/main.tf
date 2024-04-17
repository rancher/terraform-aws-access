locals {
  use               = var.use
  name              = var.name
  vpc_id            = var.vpc_id
  security_group_id = var.security_group_id
  subnet_ids        = var.subnet_ids
  access_info       = (var.access_info == null ? {} : var.access_info)
  create            = (local.use == "create" ? 1 : 0)
  select            = (local.use == "select" ? 1 : 0)
  eip               = (local.select == 1 ? data.aws_eip.selected[0] : aws_eip.created[0])
  public_ip         = (local.select == 1 ? data.aws_eip.selected[0].public_ip : aws_eip.created[0].public_ip)
}

data "aws_lb" "selected" {
  count = local.select
  tags = {
    Name = local.name
  }
}

data "aws_eip" "selected" {
  count = local.select
  filter {
    name   = "description"
    values = ["ELB net/${data.aws_lb.selected[0].name}/*"]
  }
}

resource "aws_eip" "created" {
  count  = local.create
  domain = "vpc"
}

resource "aws_security_group" "load_balancer" {
  count       = local.create
  name        = "${local.name}-lb"
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
  count              = local.create
  name               = local.name
  internal           = false
  load_balancer_type = "network"
  security_groups    = [local.security_group_id]
  dynamic "subnet_mapping" {
    for_each = toset(local.subnet_ids)
    content {
      subnet_id     = subnet_mapping.key
      allocation_id = local.eip.id
    }
  }
  tags = {
    Name = local.name
  }
}

resource "aws_lb_target_group" "created" {
  for_each = (local.create == 1 ? local.access_info : {})
  name_prefix = "${substr(md5("${local.name}-${each.key}"),0,5)}-"
  port        = each.value.port
  protocol    = upper(each.value.protocol)
  vpc_id      = local.vpc_id
  tags = {
    Name = "${local.name}-${each.key}"
  }
}

resource "aws_lb_listener" "created" {
  for_each = (local.create == 1 ? local.access_info : {})
  load_balancer_arn = aws_lb.new[0].arn
  port              = each.value.port
  protocol          = upper(each.value.protocol)
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.created[each.key].arn
  }
}
