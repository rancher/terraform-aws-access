locals {
  name      = var.name
  use       = var.use
  select    = (local.use == "select" ? 1 : 0)
  create    = (local.use == "create" ? 1 : 0)
  type_name = var.type
  type      = (local.types[var.type])
  vpc_id    = var.vpc_id
  vpc_type  = var.vpc_type
  vpc_cidr  = var.vpc_cidr
  ipv4ds    = (local.vpc_type == "dualstack" || local.vpc_type == "ipv4" ? 1 : 0)
  ipv6ds    = (local.vpc_type == "dualstack" || local.vpc_type == "ipv6" ? 1 : 0)
}

data "aws_security_group" "selected" {
  count = local.select
  filter {
    name   = "tag:Name"
    values = [local.name]
  }
}

resource "aws_security_group" "new" {
  count       = local.create
  description = "Access to ${local.type_name} generated by aws_access module"
  name        = local.name
  vpc_id      = local.vpc_id
  tags = {
    Name = local.name
  }
  lifecycle {
    ignore_changes = [
      ingress,
      egress,
    ]
  }
}

# these allow servers within the VPC to establish connections with other servers in the VPC
resource "aws_vpc_security_group_egress_rule" "project_egress_ipv4" {
  count             = (local.type.project_egress ? local.ipv4ds : 0)
  ip_protocol       = "-1"
  cidr_ipv4         = local.vpc_cidr.ipv4
  security_group_id = aws_security_group.new[0].id
}
resource "aws_vpc_security_group_egress_rule" "project_egress_ipv6" {
  count             = (local.type.project_egress ? local.ipv6ds : 0)
  ip_protocol       = "-1"
  cidr_ipv6         = local.vpc_cidr.ipv6
  security_group_id = aws_security_group.new[0].id
}

# these allow servers within the VPC to accept inbound connections from other servers in the VPC
resource "aws_vpc_security_group_ingress_rule" "project_ingress_ipv4" {
  count             = (local.type.project_ingress ? local.ipv4ds : 0)
  ip_protocol       = "-1"
  cidr_ipv4         = local.vpc_cidr.ipv4
  security_group_id = aws_security_group.new[0].id
}
resource "aws_vpc_security_group_ingress_rule" "project_ingress_ipv6" {
  count             = (local.type.project_ingress ? local.ipv6ds : 0)
  ip_protocol       = "-1"
  cidr_ipv6         = local.vpc_cidr.ipv6
  security_group_id = aws_security_group.new[0].id
}

# this is necessary if you want to update or install anything from the internet
# allows servers to initiate connections to public internet servers
resource "aws_vpc_security_group_egress_rule" "external_egress_ipv4" {
  count             = (local.type.public_egress ? local.ipv4ds : 0)
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.new[0].id
}
resource "aws_vpc_security_group_egress_rule" "external_egress_ipv6" {
  count             = (local.type.public_egress ? local.ipv6ds : 0)
  ip_protocol       = "-1"
  cidr_ipv6         = "::/0"
  security_group_id = aws_security_group.new[0].id
}


# allows the public internet to initiate connections to the server
# WARNING! this exposes your entire project to the public internet
resource "aws_vpc_security_group_ingress_rule" "external_ingress_ipv4" {
  count             = (local.type.public_ingress ? local.ipv4ds : 0)
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.new[0].id
}
resource "aws_vpc_security_group_ingress_rule" "external_ingress_ipv6" {
  count             = (local.type.public_ingress ? local.ipv6ds : 0)
  ip_protocol       = "-1"
  cidr_ipv6         = "::/0"
  security_group_id = aws_security_group.new[0].id
}
