output "vpc" {
  value = module.TestProject.vpc
}

output "subnet" {
  value = module.TestProject.subnet
}

output "security_group" {
  value = module.TestProject.security_group
}

output "ssh_key" {
  value = module.TestProject.ssh_key
}
