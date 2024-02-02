provider "aws" {
  default_tags {
    tags = {
      Id = local.identifier
    }
  }
}
locals {
  identifier = var.identifier
  name       = "tf-project-${local.identifier}"
  key_name   = var.key_name
}
module "this" {
  source              = "../../"
  owner               = "terraform-ci@suse.com"
  vpc_name            = "default" # select the default vpc
  subnet_name         = local.name
  subnet_cidr         = "172.31.254.0/24" # this must be an unused block from the vpc's cidr
  security_group_name = local.name
  security_group_type = "egress"
  ssh_key_name        = local.key_name
}
