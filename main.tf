
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
  vpc_name = var.vpc_name
  vpc_cidr = (var.vpc_cidr == "" ? "10.0.255.0/24" : var.vpc_cidr)

  # subnet
  subnets                    = var.subnets
  subnet_names               = keys(local.subnets)
  subnet_count               = length(local.subnets)
  newbits                    = (local.subnet_count > 1 ? ceil(log(local.subnet_count, 2)) : 1)
  vpc_cidr_split             = [for i in range(local.subnet_count) : cidrsubnet(local.vpc_cidr, local.newbits, i)]
  potential_regional_subnets = { for i in range(local.subnet_count) : local.subnet_names[i] => local.vpc_cidr_split[i] }

  zones                  = tolist(data.aws_availability_zones.available.names)
  potential_subnet_zones = { for i in range(local.subnet_count) : local.subnet_names[i] => local.zones[i % length(local.zones)] }

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
  cidr   = local.vpc_cidr
}

module "subnet" {
  depends_on = [
    module.vpc,
  ]
  for_each          = (local.subnet_mod == 1 ? local.subnets : {})
  source            = "./modules/subnet"
  use               = local.subnet_use_strategy
  vpc_id            = module.vpc[0].id
  name              = each.key
  cidr              = (each.value.cidr == "" ? local.potential_regional_subnets[each.key] : each.value.cidr)
  availability_zone = (each.value.availability_zone == "" ? local.potential_subnet_zones[each.key] : each.value.availability_zone)
  public            = (each.value.public == "" ? false : each.value.public)
}

module "security_group" {
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
  vpc_cidr = module.vpc[0].vpc.cidr_block
}

module "network_load_balancer" {
  depends_on = [
    module.vpc,
    module.subnet,
    module.security_group,
  ]
  count             = local.load_balancer_mod
  source            = "./modules/network_load_balancer"
  use               = local.load_balancer_use_strategy
  name              = local.load_balancer_name
  vpc_id            = module.vpc[0].id
  security_group_id = module.security_group[0].id
  subnet_ids        = [for subnet in module.subnet : subnet.id]
  access_info       = local.load_balancer_access_cidrs
}

module "domain" {
  depends_on = [
    module.vpc,
    module.subnet,
    module.security_group,
    module.network_load_balancer,
  ]
  count             = local.domain_mod
  source            = "./modules/domain"
  use               = local.domain_use_strategy
  cert_use_strategy = local.cert_use_strategy
  content           = lower(local.domain)
  ip                = module.network_load_balancer[0].public_ip
}
