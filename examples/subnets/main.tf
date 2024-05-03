
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
  example      = "subnets"
  project_name = "tf-${substr(md5(join("-", [local.example, random_pet.string.id])), 0, 5)}-${local.identifier}"
}
resource "random_pet" "string" {
  keepers = {
    # regenerate the pet name when the identifier changes
    identifier = local.identifier
  }
  length = 1
}
# AWS reserves the first four IP addresses and the last IP address in any CIDR block for its own use (cumulatively)
module "this" {
  source   = "../../"
  vpc_name = "${local.project_name}-vpc"
  vpc_cidr = "10.0.255.0/24" # gives 256 usable addresses from .1 to .254, but AWS reserves .1 to .4 and .255, leaving .5 to .254
  subnets = {
    "subnetA" = {
      cidr              = "10.0.255.0/26"
      availability_zone = "us-west-2a"
      public            = false # when true AWS will automatically provision public ips for instances in this subnet
    }
    "subnetB" = {
      cidr              = "10.0.255.64/26"
      availability_zone = "us-west-2b"
      public            = false # when true AWS will automatically provision public ips for instances in this subnet
    }
    "subnetC" = {
      cidr              = "10.0.255.128/26"
      availability_zone = "us-west-2c"
      public            = false # when true AWS will automatically provision public ips for instances in this subnet
    }
  }
  security_group_use_strategy = "skip" # everything depending on security group is skipped implicitly
}
