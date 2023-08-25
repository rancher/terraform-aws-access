output "vpc" {
  value = module.vpc.vpc
}

output "subnet" {
  value = module.subnet.subnet
}

output "cidr" {
  value = module.subnet.cidr
}

output "security_group" {
  value = module.security_group.security_group
}

output "security_group_name" {
  value = module.security_group.name
}

output "ssh_key" {
  value = module.ssh_key.ssh_key
}
