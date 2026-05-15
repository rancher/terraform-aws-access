
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
  example      = "selectvpc"
  project_name = lower(substr("tf-${substr(md5(join("-", [local.example, md5(local.identifier)])), 0, 5)}", 0, 15))
  zone         = var.zone
  domain       = lower("${local.project_name}-${local.identifier}.${local.zone}")
}

module "setup" {
  source              = "../../"
  vpc_name            = "${local.project_name}-vpc"
  subnet_use_strategy = "skip"
}

module "this" {
  depends_on = [
    module.setup
  ]
  source              = "../../"
  vpc_use_strategy    = "select"
  vpc_name            = module.setup.vpc.tags.Name
  security_group_name = "${local.project_name}-sg"
  security_group_type = "egress"
  load_balancer_name  = "${local.project_name}-lb"
  domain              = local.domain
  domain_zone         = local.zone
}
