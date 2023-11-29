locals {
  name   = var.name
  cidr   = var.cidr
  select = (var.cidr == "" ? 1 : 0)
  create = (var.cidr != "" ? 1 : 0)
}

data "aws_vpc" "selected" {
  count = local.select
  filter {
    name   = "tag:Name"
    values = [local.name]
  }
}

resource "aws_vpc" "new" {
  count      = local.create
  cidr_block = local.cidr
  tags = {
    Name = local.name
  }
  assign_generated_ipv6_cidr_block = true
}

resource "aws_internet_gateway" "new" {
  count  = local.create
  depends_on = [
    aws_vpc.new,
  ]
  vpc_id = aws_vpc.new[0].id
}

resource "aws_route" "public" {
  count                  = local.create
  depends_on = [
    aws_internet_gateway.new,
    aws_vpc.new,
  ]
  route_table_id         = aws_vpc.new[0].default_route_table_id
  gateway_id             = aws_internet_gateway.new[0].id
  destination_cidr_block = "0.0.0.0/0"
}
