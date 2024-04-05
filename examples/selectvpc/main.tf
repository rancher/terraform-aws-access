
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
  identifier = var.identifier
  name       = "tf-${local.identifier}"
  domain     = "${local.identifier}-${var.domain}"
}

module "setup" {
  source              = "../../"
  vpc_name            = local.name
  vpc_cidr            = "10.0.255.0/24"
  subnet_use_strategy = "skip"
}

module "this" {
  depends_on = [
    module.setup
  ]
  source              = "../../"
  vpc_use_strategy    = "select"
  vpc_name            = module.setup.vpc.tags.Name
  security_group_name = local.name
  security_group_type = "egress"
  load_balancer_name  = local.name
  domain              = local.domain
}
