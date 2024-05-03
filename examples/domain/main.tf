
provider "aws" {
  default_tags {
    tags = {
      Id    = local.identifier
      Owner = local.owner
    }
  }
}
provider "acme" {
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
}
locals {
  identifier   = var.identifier
  example      = "domain"
  project_name = "tf-${substr(md5(join("-", [local.example, random_pet.string.id])), 0, 5)}-${local.identifier}"
  owner        = "terraform-ci@suse.com"
  zone         = var.zone
  domain       = "${local.identifier}.${local.zone}"
  #zone = var.domain_zone
}
resource "random_pet" "string" {
  keepers = {
    # regenerate the pet name when the identifier changes
    identifier = local.identifier
  }
  length = 1
}
# AWS reserves the first four IP addresses and the last IP address in any CIDR block for its own use (cumulatively)
module "this" {
  source              = "../../"
  vpc_name            = "${local.project_name}-vpc"
  vpc_cidr            = "10.0.255.0/24" # gives 256 usable addresses from .1 to .254, but AWS reserves .1 to .4 and .255, leaving .5 to .254
  security_group_name = "${local.project_name}-sg"
  security_group_type = "project"
  load_balancer_name  = "${local.project_name}-lb"
  domain              = local.domain
  #domain_zone         = local.zone # only specify when creating a new zone
}
