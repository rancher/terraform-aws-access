provider "aws" {
  default_tags {
    tags = {
      Id = local.identifier
    }
  }
}
locals {
  identifier = var.identifier
  name       = "tf-sgip-${local.identifier}"
}

module "this" {
  source              = "../../"
  owner               = "terraform-ci@suse.com"
  vpc_name            = local.name
  vpc_cidr            = "10.0.255.0/24" # gives 256 usable addresses from .1 to .254, but AWS reserves .1 to .4 and .255, leaving .5 to .254
  skip_subnet         = true
  security_group_name = local.name
  security_group_type = "specific"
  security_group_ip   = "192.168.1.1"
  skip_ssh            = true
}
