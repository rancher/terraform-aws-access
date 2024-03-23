provider "aws" {
  default_tags {
    tags = {
      Id = local.identifier
    }
  }
}
locals {
  identifier          = var.identifier
  security_group_name = var.security_group_name
  key_name            = var.key_name
}
module "this" {
  source              = "../../"
  vpc_name            = "default"
  subnet_name         = "default"
  security_group_name = local.security_group_name
  ssh_key_name        = local.key_name
}
