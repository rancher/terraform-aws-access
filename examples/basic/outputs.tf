output "vpc" {
  value = module.TestBasic.vpc
}

output "subnet" {
  value = module.TestBasic.subnet
}

output "security_group" {
  value = module.TestBasic.security_group
}

output "ssh_key" {
  value = module.TestBasic.ssh_key
}
