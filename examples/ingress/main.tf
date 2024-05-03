
provider "aws" {
  default_tags {
    tags = {
      Id    = local.identifier
      Owner = "terraform-ci@suse.com"
    }
  }
}
provider "acme" {
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory" # use this url in test
  #server_url = "https://acme-v02.api.letsencrypt.org/directory" # use this url in production
}
locals {
  identifier   = var.identifier
  example      = "ingress"
  project_name = "tf-${substr(md5(join("-", [local.example, md5(local.identifier)])), 0, 5)}-${local.identifier}"
  zone         = var.zone
  domain       = "${local.identifier}.${local.zone}"
}

# AWS reserves the first four IP addresses and the last IP address in any CIDR block for its own use (cumulatively)
module "this" {
  source              = "../../"
  vpc_name            = "${local.project_name}-vpc"
  vpc_cidr            = "10.0.255.0/24" # gives 256 usable addresses from .1 to .254, but AWS reserves .1 to .4 and .255, leaving .5 to .254
  security_group_name = "${local.project_name}-sg"
  security_group_type = "egress"
  domain              = local.domain
  load_balancer_name  = "${local.project_name}-lb"
  load_balancer_access_cidrs = {
    application = {
      port     = 443
      protocol = "tcp"
      cidrs    = ["1.1.1.1/32"]
    }
    platform = {
      port     = 6443
      protocol = "tcp"
      cidrs    = ["2.2.2.2/32"]
    }
  }
}
