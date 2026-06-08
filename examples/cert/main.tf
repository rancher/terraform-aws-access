
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
  example      = "cert"
  project_name = lower(substr("tf-${substr(md5(join("-", [local.example, md5(local.identifier)])), 0, 5)}", 0, 15))
  owner        = "terraform-ci@suse.com"
  zone         = var.zone
  domain       = lower("${local.project_name}-${local.identifier}.${local.zone}")
  az           = data.aws_availability_zones.available.names
  subnet_names = [for z in local.az : "${local.project_name}-subnet-${z}"][0]
}

data "aws_availability_zones" "available" {
  state = "available"
}

# AWS reserves the first four IP addresses and the last IP address in any CIDR block for its own use (cumulatively)
module "this" {
  source              = "../../"
  vpc_name            = "${local.project_name}-vpc"
  subnet_names        = [local.subnet_names]
  security_group_name = "${local.project_name}-sg"
  security_group_type = "project"
  load_balancer_name  = "${local.project_name}-lb"
  domain              = local.domain
  domain_zone         = local.zone
  cert_use_strategy   = "create"
}
