locals {
  use               = var.use
  select            = (local.use == "select" ? 1 : 0)
  create            = (local.use == "create" ? 1 : 0)
  vpc_id            = var.vpc_id
  ipv6_cidr         = var.ipv6_cidr
  ipv4_cidr         = var.ipv4_cidr
  type              = var.type
  ipv6ds            = ((local.type == "ipv6" || local.type == "dualstack") ? local.create : 0)
  availability_zone = var.availability_zone
  public            = var.public
  name              = var.name
}

data "aws_subnet" "selected" {
  count = local.select
  filter {
    name   = "tag:Name"
    values = [local.name]
  }
}

resource "aws_subnet" "created" {
  count                           = local.create
  vpc_id                          = local.vpc_id
  cidr_block                      = local.ipv4_cidr
  ipv6_cidr_block                 = local.ipv6_cidr
  assign_ipv6_address_on_creation = (local.ipv6ds == 1 ? true : false)
  availability_zone               = local.availability_zone
  map_public_ip_on_launch         = local.public
  tags = {
    Name = local.name
  }
}
