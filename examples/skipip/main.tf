provider "aws" {
  default_tags {
    tags = {
      Id = local.identifier
    }
  }
}

locals {
  identifier = var.identifier
  name       = "tf-skipip-${local.identifier}"

}

module "this" {
  source              = "../../"
  owner               = "terraform-ci@suse.com"
  vpc_name            = local.name
  vpc_cidr            = "10.0.255.0/24" # gives 256 usable addresses from .1 to .254, but AWS reserves .1 to .4 and .255, leaving .5 to .254
  subnet_name         = local.name
  subnet_cidr         = "10.0.255.224/28" # gives 14 usable addresses from .225 to .238, but AWS reserves .225 to .227 and .238, leaving .227 to .237
  security_group_name = local.name
  security_group_type = "internal" # air gapped, internal only and no holes
  skip_runner_ip      = true       # air gapped, internal only and no holes
  skip_ssh            = true
}
