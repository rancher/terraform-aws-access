locals {
  use               = var.use
  name              = var.name
  security_group_id = var.security_group_id
  subnet_ids        = var.subnet_ids
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
