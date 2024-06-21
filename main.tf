
locals {
  vpc_use_strategy = var.vpc_use_strategy
  vpc_mod = (
    local.vpc_use_strategy == "skip" ? 0 : 1
  )
  subnet_use_strategy = var.subnet_use_strategy
  subnet_mod = (
    local.subnet_use_strategy == "skip" ? 0 : (
      local.vpc_use_strategy == "skip" ? 0 : 1 # subnet mod requires vpc mod
    )
  )
  security_group_use_strategy = var.security_group_use_strategy
  security_group_mod = (
    local.security_group_use_strategy == "skip" ? 0 : (
      local.subnet_use_strategy == "skip" ? 0 : ( # security group mod requires subnet mod
        local.vpc_use_strategy == "skip" ? 0 : 1  # security group mod requires vpc mod
      )
    )
  )
  load_balancer_use_strategy = var.load_balancer_use_strategy
  load_balancer_mod = (
    local.load_balancer_use_strategy == "skip" ? 0 : (
      local.security_group_use_strategy == "skip" ? 0 : ( # load balancer mod requires security group mod
        local.subnet_use_strategy == "skip" ? 0 : (       # load balancer mod requires subnet mod
          local.vpc_use_strategy == "skip" ? 0 : 1        # load balancer mod requires vpc mod
        )
      )
    )
  )

  domain_use_strategy = var.domain_use_strategy
  domain_mod = (
    local.domain_use_strategy == "skip" ? 0 : (
      local.load_balancer_use_strategy == "skip" ? 0 : (    # domain mod requires load balancer mod
        local.security_group_use_strategy == "skip" ? 0 : ( # domain mod requires security group mod
          local.subnet_use_strategy == "skip" ? 0 : (       # domain mod requires subnet mod
            local.vpc_use_strategy == "skip" ? 0 : 1        # domain mod requires vpc mod
          )
        )
      )
    )
  )

  # vpc
  vpc_name   = var.vpc_name
  vpc_type   = var.vpc_type
  vpc_zones  = var.vpc_zones
  vpc_public = var.vpc_public
  vpc_cidr   = var.vpc_cidr

  # subnet
  availability_zones = (length(local.vpc_zones) > 0 ?
    ({ for i in length(local.vpc_zones) : tostring(i) => local.vpc_zones[i] }) :
    ({ "0" = data.aws_availability_zones.available.names[0] })
  )

  # security group
  security_group_name = var.security_group_name
  security_group_type = var.security_group_type

  # domain
  domain            = var.domain
  cert_use_strategy = var.cert_use_strategy

  # load balancer
  load_balancer_name         = var.load_balancer_name
  load_balancer_access_cidrs = var.load_balancer_access_cidrs
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  count  = local.vpc_mod
  source = "./modules/vpc"
  use    = local.vpc_use_strategy
  name   = local.vpc_name
  type   = local.vpc_type
}

module "subnet" {
  depends_on = [
    module.vpc,
  ]
  for_each          = (local.subnet_mod == 1 ? local.availability_zones : tomap({}))
  source            = "./modules/subnet"
  use               = local.subnet_use_strategy
  type              = local.vpc_type
  vpc_id            = module.vpc[0].id
  vpc_cidr          = local.vpc_cidr
  name              = "${local.vpc_name}-${each.value}"
  availability_zone = each.value
  public            = local.vpc_public
}

module "project_security_group" {
  depends_on = [
    module.subnet,
    module.vpc,
  ]
  count    = local.security_group_mod
  source   = "./modules/security_group"
  use      = local.security_group_use_strategy
  name     = local.security_group_name
  type     = local.security_group_type
  vpc_id   = module.vpc[0].id
  vpc_type = local.vpc_type
  vpc_cidr = {
    ipv4 = module.vpc[0].ipv4
    ipv6 = module.vpc[0].ipv6
  }
}

module "network_load_balancer" {
  depends_on = [
    module.vpc,
    module.subnet,
    module.project_security_group,
  ]
  count             = local.load_balancer_mod
  source            = "./modules/network_load_balancer"
  use               = local.load_balancer_use_strategy
  name              = local.load_balancer_name
  vpc_id            = module.vpc[0].id
  vpc_type          = local.vpc_type
  security_group_id = module.project_security_group[0].id
  access_info       = local.load_balancer_access_cidrs
  subnets           = module.subnet
}

module "domain" {
  depends_on = [
    module.vpc,
    module.subnet,
    module.project_security_group,
    module.network_load_balancer,
  ]
  count             = local.domain_mod
  source            = "./modules/domain"
  use               = local.domain_use_strategy
  cert_use_strategy = local.cert_use_strategy
  content           = lower(local.domain)
  ips               = module.network_load_balancer[0].public_ips
}
