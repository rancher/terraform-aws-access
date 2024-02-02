provider "aws" {
  default_tags {
    tags = {
      Id = local.identifier
    }
  }
}
locals {
  identifier = var.identifier
  key        = var.key
  key_name   = var.key_name
}
# generate vpc, security group, and ssh key
module "this" {
  source              = "../../"
  owner               = "terraform-ci@suse.com"
  vpc_name            = "tf-${local.identifier}"
  vpc_cidr            = "10.0.255.0/24" # gives 256 usable addresses from .1 to .254, but AWS reserves .1 to .4 and .255, leaving .5 to .254
  skip_subnet         = true
  security_group_name = "tf-${local.identifier}"
  security_group_type = "specific"
  security_group_ip   = "192.168.0.1"
  public_ssh_key      = local.key
  ssh_key_name        = local.key_name
}
