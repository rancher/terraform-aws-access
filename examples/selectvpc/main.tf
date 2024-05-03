
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
  project_name = "tf-${substr(md5(join("-", [local.example, md5(local.identifier)])), 0, 5)}-${local.identifier}"
  zone         = var.zone
  domain       = "${local.identifier}.${local.zone}"
}

module "setup" {
  source              = "../../"
  vpc_name            = "${local.project_name}-vpc"
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
  security_group_name = "${local.project_name}-sg"
  security_group_type = "egress"
  load_balancer_name  = "${local.project_name}-lb"
  domain              = local.domain
}
