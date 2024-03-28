locals {
  use               = var.use
  select            = (local.use == "select" ? 1 : 0)
  create            = (local.use == "create" ? 1 : 0)
  name              = var.name
  vpc_id            = var.vpc_id
  cidr              = var.cidr
  availability_zone = var.availability_zone
  public            = var.public
}

data "aws_subnet" "selected" {
  count = local.select
  filter {
    name   = "tag:Name"
    values = [local.name]
  }
}

resource "aws_subnet" "new" {
  count                   = local.create
  vpc_id                  = local.vpc_id
  cidr_block              = local.cidr
  availability_zone       = local.availability_zone
  map_public_ip_on_launch = local.public
  tags = {
    Name = local.name
  }
}
