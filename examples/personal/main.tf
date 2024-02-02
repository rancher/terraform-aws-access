provider "aws" {
  default_tags {
    tags = {
      Id = local.identifier
    }
  }
}
locals {
  key        = var.key
  key_name   = var.key_name
  identifier = var.identifier
}
module "TestPersonal" {
  source              = "../../"
  owner               = "terraform-ci@suse.com" # update this to your email or a group email, the resources will be tagged with this
  vpc_name            = "default"               # select the default vpc
  subnet_name         = "default"               # select the default subnet
  security_group_name = "tf-${local.identifier}"
  security_group_type = "egress"
  public_ssh_key      = local.key
  ssh_key_name        = local.key_name
}
