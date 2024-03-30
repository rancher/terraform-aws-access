
provider "aws" {
  default_tags {
    tags = {
      Id    = local.identifier
      Owner = local.owner
    }
  }
}
locals {
  identifier = var.identifier
  name       = "tf-dns-${local.identifier}"
  owner      = "terraform-ci@suse.com"
  domain     = var.domain
  #zone = var.domain_zone
}
# AWS reserves the first four IP addresses and the last IP address in any CIDR block for its own use (cumulatively)
module "this" {
  source              = "../../"
  vpc_name            = local.name
  vpc_cidr            = "10.0.255.0/24" # gives 256 usable addresses from .1 to .254, but AWS reserves .1 to .4 and .255, leaving .5 to .254
  security_group_name = local.name
  security_group_type = "project"
  load_balancer_name  = local.name
  domain              = local.domain
  #domain_zone         = local.zone # only specify when creating a new zone
}
