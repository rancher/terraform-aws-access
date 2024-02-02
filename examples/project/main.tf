provider "aws" {
  default_tags {
    tags = {
      Id = local.identifier
    }
  }
}
locals {
  key_name   = var.key_name
  identifier = var.identifier
}
module "TestProject" {
  source              = "../../"
  owner               = "terraform-ci@suse.com"
  vpc_name            = "default" # select the default vpc
  subnet_name         = "tf-${local.identifier}"
  subnet_cidr         = "172.31.254.0/24" # this must be an unused block from the vpc's cidr
  security_group_name = "tf-${local.identifier}"
  security_group_type = "egress"
  ssh_key_name        = local.key_name
}
