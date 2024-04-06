locals {
  use               = var.use
  name              = var.name
  vpc_id            = var.vpc_id
  security_group_id = var.security_group_id
  subnet_ids        = var.subnet_ids
  access_cidrs      = var.access_cidrs
  create            = (local.use == "create" ? 1 : 0)
  select            = (local.use == "select" ? 1 : 0)

  public_ip = (local.select == 1 ? data.aws_eip.selected[0].public_ip : aws_eip.created[0].public_ip)
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
  for_each          = (local.create == 1 ? local.access_cidrs : {})
  security_group_id = aws_security_group.load_balancer[0].id
  type              = "ingress"
  from_port         = each.key
  to_port           = each.key
  protocol          = "-1"
  cidr_blocks       = each.value
}

resource "aws_lb" "new" {
  count              = local.create
  name               = local.name
  internal           = false
  load_balancer_type = "network"
  security_groups    = [local.security_group_id]
  subnets            = local.subnet_ids

  tags = {
    Name = local.name
  }
}
