output "vpc" {
  value = module.TestOverride.vpc
}

output "subnet" {
  value = module.TestOverride.subnet
}

output "security_group" {
  value = module.TestOverride.security_group
}

output "ssh_key" {
  value = module.TestOverride.ssh_key
}
