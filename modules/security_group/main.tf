locals {
  name           = var.name
  select         = (var.type == "" ? 1 : 0) # select if no type given
  create         = (var.type != "" ? 1 : 0) # create if given a type
  type           = (local.types[(var.type == "" ? "none" : var.type)])
  owner          = var.owner
  ip             = chomp(var.ip)
  cidr           = var.cidr
  vpc_id         = var.vpc_id
  vpc_cidr       = var.vpc_cidr
  skip_runner_ip = var.skip_runner_ip
  allow_runner   = (local.skip_runner_ip ? false : true) # opposite of skip_runner_ip
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
  description = "security group generated by aws_access module"
  name        = local.name
  vpc_id      = local.vpc_id
  tags = {
    Name  = local.name
    Owner = local.owner
  }
  lifecycle {
    ignore_changes = [
      ingress,
      egress,
    ]
  }
}

# this rule allows ingress on any port from the ip specified
resource "aws_vpc_security_group_ingress_rule" "from_ip" {
  count             = (local.type.specific_ip_ingress && local.allow_runner ? 1 : 0)
  ip_protocol       = "-1"
  cidr_ipv4         = "${local.ip}/32"
  security_group_id = aws_security_group.new[0].id
}
# this rule allows egress on any port to the ip specified
resource "aws_vpc_security_group_egress_rule" "to_ip" {
  count             = (local.type.specific_ip_egress && local.allow_runner ? 1 : 0)
  ip_protocol       = "-1"
  cidr_ipv4         = "${local.ip}/32"
  security_group_id = aws_security_group.new[0].id
}

# this rule allows any ip in the cidr on any port to initiate connections to the server
resource "aws_vpc_security_group_ingress_rule" "internal_ingress" {
  count             = (local.type.internal_ingress ? 1 : 0)
  ip_protocol       = "-1"
  cidr_ipv4         = local.cidr
  security_group_id = aws_security_group.new[0].id
}
# this rule allows the server to initiate connections to any ip in the cidr on any port
resource "aws_vpc_security_group_egress_rule" "internal_egress" {
  count             = (local.type.internal_egress ? 1 : 0)
  ip_protocol       = "-1"
  cidr_ipv4         = local.cidr
  security_group_id = aws_security_group.new[0].id
}
# this rule allows any ip in the cidr on any port to initiate connections to the server
resource "aws_vpc_security_group_ingress_rule" "project_ingress" {
  count             = (local.type.project_ingress ? 1 : 0)
  ip_protocol       = "-1"
  cidr_ipv4         = local.vpc_cidr
  security_group_id = aws_security_group.new[0].id
}
# this rule allows the server to initiate connections to any ip in the cidr on any port
resource "aws_vpc_security_group_egress_rule" "project_egress" {
  count             = (local.type.project_egress ? 1 : 0)
  ip_protocol       = "-1"
  cidr_ipv4         = local.vpc_cidr
  security_group_id = aws_security_group.new[0].id
}
# this is necessary if you want to update or install anything from the internet
# allows server to initiate connections to anywhere
resource "aws_vpc_security_group_egress_rule" "external_egress" {
  count             = (local.type.public_egress ? 1 : 0)
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.new[0].id
}
# allows anywhere to initiate connections to server
# WARNING! this exposes your server to the public internet
resource "aws_vpc_security_group_ingress_rule" "external_ingress" {
  count             = (local.type.public_ingress ? 1 : 0)
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.new[0].id
}
