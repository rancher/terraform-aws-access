
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
  example      = "loadbalancer"
  project_name = "tf-${substr(md5(join("-", [local.example, md5(local.identifier)])), 0, 5)}-${local.identifier}"
}

# AWS reserves the first four IP addresses and the last IP address in any CIDR block for its own use (cumulatively)
module "this" {
  source              = "../../"
  vpc_name            = "${local.project_name}-vpc"
  security_group_name = "${local.project_name}-sg"
  security_group_type = "project"
  load_balancer_name  = "${local.project_name}-lb"
  domain_use_strategy = "skip"
}
