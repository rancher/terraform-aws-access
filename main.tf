
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
  count             = (local.skip_subnet ? 0 : 1)
  source            = "./modules/subnet"
  name              = local.subnet_name
  cidr              = local.subnet_cidr
  vpc_id            = module.vpc[0].id
  owner             = local.owner
  availability_zone = local.subnet_availability_zone
  public_ip         = local.subnet_public_ip
}

module "security_group" {
  count          = (local.skip_security_group ? 0 : 1)
  source         = "./modules/security_group"
  name           = local.security_group_name
  ip             = local.ip
  cidr           = (can(module.subnet[0].cidr) ? module.subnet[0].cidr : "")
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
