locals {
  select     = (var.public_key == "" ? 1 : 0)
  create     = (var.public_key != "" ? 1 : 0)
  name       = var.name
  public_key = var.public_key
  owner      = var.owner
}

data "aws_key_pair" "selected" {
  count = local.select
  filter {
    name   = "tag:Name"
    values = [local.name]
  }
  include_public_key = true
}

resource "aws_key_pair" "new" {
  count      = local.create
  key_name   = local.name
  public_key = local.public_key
  tags = {
    Name  = local.name
    Owner = local.owner
  }
}
