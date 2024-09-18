
provider "aws" {
  default_tags {
    tags = {
      Id    = local.identifier
      Owner = "terraform-ci@suse.com"
    }
  }
}
provider "acme" {
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
}
locals {
  identifier   = var.identifier
  example      = "selectsubnets"
  project_name = lower(substr("tf-${substr(md5(join("-", [local.example, md5(local.identifier)])), 0, 5)}-${local.identifier}", 0, 25))
  zone         = var.zone
  domain       = "${local.project_name}.${local.zone}"
}

module "setup" {
  source                      = "../../"
  vpc_name                    = local.project_name
  subnet_names                = [local.project_name]
  security_group_use_strategy = "skip"
}

# AWS reserves the first four IP addresses and the last IP address in any CIDR block for its own use (cumulatively)
# gives 256 usable addresses from .1 to .254, but AWS reserves .1 to .4 and .255, leaving .5 to .254
module "this" {
  depends_on = [
    module.setup,
  ]
  source              = "../../"
  vpc_use_strategy    = "select"
  vpc_name            = local.project_name
  subnet_use_strategy = "select"
  subnet_names        = [local.project_name]
  security_group_name = "${local.project_name}-sg"
  security_group_type = "egress"
  load_balancer_name  = "${local.project_name}-lb"
  domain              = local.domain
  domain_zone         = local.zone
}
