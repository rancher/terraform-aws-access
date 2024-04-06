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
}
module "this" {
  source           = "../../"
  vpc_use_strategy = "skip" # everything depending on vpc is skipped implicitly
}
