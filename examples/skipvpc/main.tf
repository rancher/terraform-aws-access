provider "aws" {
  default_tags {
    tags = {
      Id    = local.identifier
      Owner = "terraform-ci@suse.com"
    }
  }
}
locals {
  identifier = var.identifier
}
module "this" {
  source           = "../../"
  vpc_use_strategy = "skip" # everything depending on vpc is skipped implicitly
}
