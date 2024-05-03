
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
  project_name = "tf-${substr(md5(join("-", [local.example, md5(local.identifier)])), 0, 5)}-${local.identifier}"
}

# AWS reserves the first four IP addresses and the last IP address in any CIDR block for its own use (cumulatively)
module "this" {
  source   = "../../"
  vpc_name = "${local.project_name}-vpc"
  vpc_cidr = "10.0.255.0/24" # gives 256 usable addresses from .1 to .254, but AWS reserves .1 to .4 and .255, leaving .5 to .254
  subnets = {
    "${local.project_name}A" = {
      cidr              = "10.0.255.0/26"
      availability_zone = "us-west-2a"
      public            = false # when true AWS will automatically provision public ips for instances in this subnet
    }
    "${local.project_name}B" = {
      cidr              = "10.0.255.64/26"
      availability_zone = "us-west-2b"
      public            = false # when true AWS will automatically provision public ips for instances in this subnet
    }
    "${local.project_name}C" = {
      cidr              = "10.0.255.128/26"
      availability_zone = "us-west-2c"
      public            = false # when true AWS will automatically provision public ips for instances in this subnet
    }
  }
  security_group_use_strategy = "skip" # everything depending on security group is skipped implicitly
}
