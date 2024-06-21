locals {
  use               = var.use
  select            = (local.use == "select" ? 1 : 0)
  create            = (local.use != "select" ? 1 : 0)
  vpc_id            = var.vpc_id
  vpc_cidr          = var.vpc_cidr
  type              = var.type
  ipv4              = ((local.type == "dualstack" || local.type == "ipv4") ? local.create : 0)
  ipv6              = (local.type == "ipv6" ? local.create : 0)
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

resource "aws_subnet" "ipv6" {
  count                                          = local.ipv6
  vpc_id                                         = local.vpc_id
  availability_zone                              = local.availability_zone
  map_public_ip_on_launch                        = local.public
  ipv6_cidr_block                                = (can(local.vpc_cidr.ipv6) ? local.vpc_cidr.ipv6 : "")
  ipv6_native                                    = true
  assign_ipv6_address_on_creation                = true
  enable_resource_name_dns_aaaa_record_on_launch = true
  tags = {
    Name = local.name
  }
}

resource "aws_subnet" "ipv4" {
  count                           = local.ipv4
  vpc_id                          = local.vpc_id
  cidr_block                      = (can(local.vpc_cidr.ipv4) ? local.vpc_cidr.ipv4 : "")
  assign_ipv6_address_on_creation = (local.type == "dualstack" ? true : false)
  availability_zone               = local.availability_zone
  map_public_ip_on_launch         = local.public
  tags = {
    Name = local.name
  }
}
