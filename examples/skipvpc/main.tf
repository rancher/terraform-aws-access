provider "aws" {
  default_tags {
    tags = {
      Id = local.identifier
    }
  }
}
locals {
  identifier = var.identifier
  name       = "tf-skipsubnet-${local.identifier}"
  key        = var.key
  key_name   = var.key_name
}
module "this" {
  source              = "../../"
  owner               = "terraform-ci@suse.com"
  skip_vpc            = true
  skip_subnet         = true # without a vpc selected or created subnet can't be created
  skip_security_group = true # without a vpc selected of created security group can't be created
  public_ssh_key      = local.key
  ssh_key_name        = local.key_name
}
