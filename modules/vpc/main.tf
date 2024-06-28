locals {
  name      = var.name
  use       = var.use
  type      = var.type
  select    = (local.use == "select" ? 1 : 0)
  create    = (local.use == "create" ? 1 : 0)
  ipv6      = (local.type == "ipv6" ? local.create : 0)
  ipv4      = (local.type == "ipv4" ? local.create : 0)
  dualstack = (local.type == "dualstack" ? local.create : 0)
  ipv6ds    = ((local.type == "dualstack" || local.type == "ipv6") ? local.create : 0)
  ipv4ds    = ((local.type == "dualstack" || local.type == "ipv4") ? local.create : 0)
}

data "aws_vpc" "selected" {
  count = local.select
  filter {
    name   = "tag:Name"
    values = [local.name]
  }
}

resource "aws_vpc" "new" {
  count                            = local.create
  cidr_block                       = "10.0.0.0/16"
  assign_generated_ipv6_cidr_block = true
  tags = {
    Name = local.name
  }
}

resource "aws_internet_gateway" "new" {
  count = local.create
  depends_on = [
    aws_vpc.new,
  ]
  vpc_id = aws_vpc.new[0].id
}

resource "aws_route" "public_ipv4" {
  count = local.ipv4ds
  depends_on = [
    aws_internet_gateway.new,
    aws_vpc.new,
  ]
  route_table_id         = aws_vpc.new[0].default_route_table_id
  gateway_id             = aws_internet_gateway.new[0].id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "public_ipv6" {
  count = local.ipv6ds
  depends_on = [
    aws_internet_gateway.new,
    aws_vpc.new,
  ]
  route_table_id              = aws_vpc.new[0].default_route_table_id
  gateway_id                  = aws_internet_gateway.new[0].id
  destination_ipv6_cidr_block = "::/0"
}
