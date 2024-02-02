output "vpc" {
  value = module.this.vpc
}

output "subnet" {
  value = module.this.subnet
}

output "security_group" {
  value = module.this.security_group
}

output "ssh_key" {
  value = module.this.ssh_key
}
