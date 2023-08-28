output "vpc" {
  value       = module.vpc.vpc
  description = <<-EOT
    The VPC object from AWS.
  EOT
}

output "subnet" {
  value       = module.subnet.subnet
  description = <<-EOT
    The subnet object from AWS.
  EOT
}

output "cidr" {
  value       = module.subnet.cidr
  description = <<-EOT
    The CIDR block of the subnet.
  EOT
}

output "security_group" {
  value       = module.security_group.security_group
  description = <<-EOT
    The security group object from AWS.
  EOT
}

output "security_group_name" {
  value       = module.security_group.name
  description = <<-EOT
    The name of the security group.
  EOT
}

output "ssh_key" {
  value       = module.ssh_key.ssh_key
  description = <<-EOT
    The SSH key object from AWS.
  EOT
}
