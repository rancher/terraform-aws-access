
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
  example      = "vpc"
  project_name = lower(substr("tf-${substr(md5(join("-", [local.example, md5(local.identifier)])), 0, 5)}-${local.identifier}", 0, 25))
}

# AWS reserves the first four IP addresses and the last IP address in any CIDR block for its own use (cumulatively)
module "this" {
  source              = "../../"
  vpc_name            = "${local.project_name}-vpc"
  subnet_use_strategy = "skip" # everything depending on subnet is skipped implicitly
}
