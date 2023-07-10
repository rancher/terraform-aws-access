output "vpc" {
  value = module.TestPersonal.vpc
}

output "subnet" {
    value = module.TestPersonal.subnet
}

output "cidr" {
    value = module.TestPersonal.cidr
}

output "security_group" {
    value = module.TestPersonal.security_group
}

output "ssh_key" {
    value = module.TestPersonal.ssh_key
}
