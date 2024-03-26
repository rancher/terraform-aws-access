
locals {
  owner = var.owner

  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr # create when cidr is given, otherwise select with name or skip
  skip_vpc = var.skip_vpc # both subnet and security group need a vpc, but vpc is not necessary for ssh key

  subnet_name              = var.subnet_name
  subnet_cidr              = var.subnet_cidr       # create when cidr is given, otherwise select with name or skip
  subnet_availability_zone = var.availability_zone # only used when creating
  subnet_public_ip         = var.subnet_public_ip  # set this to true to enable public ip addressing on servers
  skip_subnet              = var.skip_subnet       # if using the "specific" security group type you can skip subnet creation

  security_group_name = var.security_group_name
  security_group_type = var.security_group_type # create when type is given, otherwise select with name or skip
  security_group_ip   = var.security_group_ip
  ipinfo_ip           = chomp(can(data.http.my_public_ip[0].response_body) ? data.http.my_public_ip[0].response_body : "127.0.0.1")
  ip                  = (local.security_group_ip == "" ? local.ipinfo_ip : local.security_group_ip)
  skip_security_group = var.skip_security_group # no objects in this module depend on security group being created, skip if wanted
  skip_runner_ip      = var.skip_runner_ip
  ssh_key_name        = var.ssh_key_name
  public_ssh_key      = var.public_ssh_key # create when public key is given, otherwise select with name
  skip_ssh            = var.skip_ssh       # no objects in this module depend on ssh key being created, skip if wanted

  zone   = var.zone # if a zone is given, we will create a zone record, otherwise we will attempt to find it
  domain = var.domain # only create a domain record if a load balancer name is given
  add_domain = (var.load_balancer_name == "" ? false : true)

  skip_lb            = var.skip_lb
  load_balancer_name = var.load_balancer_name # if a load balancer name is given, we will create a load balancer
  select_lb          = var.select_lb # if true we will select a load balancer, otherwise we will create one
  create_lb = (local.select_lb ? false : true) # create_lb is the opposite of select_lb
  # if a domain and a load balancer name is given, we will create a domain record pointing to the load balancer
}

data "http" "my_public_ip" {
  count = (local.security_group_ip == "" ? 1 : 0)
  url   = "https://ipinfo.io/ip"
}

module "vpc" {
  count  = (local.skip_vpc ? 0 : 1)
  source = "./modules/vpc"
  name   = local.vpc_name
  cidr   = local.vpc_cidr
}

module "subnet" {
  depends_on = [
    module.vpc,
  ]
  count             = ((local.skip_subnet || local.skip_vpc) ? 0 : 1)
  source            = "./modules/subnet"
  name              = local.subnet_name
  cidr              = local.subnet_cidr
  vpc_id            = module.vpc[0].id
  owner             = local.owner
  availability_zone = local.subnet_availability_zone
  public_ip         = local.subnet_public_ip
}

module "security_group" {
  depends_on = [
    module.subnet,
    module.vpc,
  ]
  count          = ((local.skip_security_group || local.skip_subnet || local.skip_vpc) ? 0 : 1)
  source         = "./modules/security_group"
  name           = local.security_group_name
  ip             = local.ip
  cidr           = module.subnet[0].cidr
  owner          = local.owner
  type           = local.security_group_type
  vpc_id         = module.vpc[0].id
  vpc_cidr       = module.vpc[0].vpc.cidr_block
  skip_runner_ip = local.skip_runner_ip
}

module "ssh_key" {
  count      = (local.skip_ssh ? 0 : 1)
  source     = "./modules/ssh_key"
  name       = local.ssh_key_name
  public_key = local.public_ssh_key
  owner      = local.owner
}

module "network_load_balancer" {
  depends_on = [
    module.vpc,
    module.subnet,
    module.security_group,
  ]
  count             = ((local.skip_lb || local.skip_security_group || local.skip_subnet || local.skip_vpc) ? 0 : 1)
  source            = "./modules/network_load_balancer"
  owner             = local.owner
  name              = local.load_balancer_name
  create            = local.create_lb
  security_group_id = module.security_group[0].id
  subnet_id         = module.subnet[0].id
  vpc_id            = module.vpc[0].id
}

module "domain" {
  depends_on = [
    module.vpc,
    module.subnet,
    module.security_group,
    module.network_load_balancer,
  ]
  count   = ((local.domain == "" && local.zone == "") ? 0 : 1)
  source  = "./modules/domain"
  owner   = local.owner
  create = local.add_domain
  content = local.domain
  zone    = local.zone
  alias   = (length(module.network_load_balancer) > 0 ? module.network_load_balancer[0].dns_name : "")
}
