provider "aws" {
  default_tags {
    tags = {
      Id = local.identifier
    }
  }
}

locals {
  identifier = var.identifier
  name       = "tf-specifyip-${local.identifier}"
  key        = var.key
  key_name   = var.key_name
  ip         = var.ip
}

module "this" {
  source              = "../../"
  owner               = "terraform-ci@suse.com"
  vpc_name            = local.name
  vpc_cidr            = "10.0.255.0/24" # gives 256 usable addresses from .1 to .254, but AWS reserves .1 to .4 and .255, leaving .5 to .254
  subnet_name         = local.name
  subnet_cidr         = "10.0.255.224/28" # gives 14 usable addresses from .225 to .238, but AWS reserves .225 to .227 and .238, leaving .227 to .237
  availability_zone   = "us-west-1b"      # check what availability zones are available in your region before setting this
  security_group_name = local.name
  security_group_type = "egress"
  security_group_ip   = chomp(local.ip)
  public_ssh_key      = local.key
  ssh_key_name        = local.key_name
}
