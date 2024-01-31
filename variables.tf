variable "owner" {
  type        = string
  description = <<-EOT
    The name of the owner to tag resources with, usually your email address.
    Using your email address for this value allows teammates and other users 
     to contact you if a resource needs to be removed or if they have questions about it.
  EOT
  default     = ""
}
# vpc
variable "vpc_name" {
  type        = string
  description = <<-EOT
    The name of the VPC to create or select.
    This is required.
    If a cidr is specified, then a VPC will be created.
  EOT
  default     = ""
}
variable "vpc_cidr" {
  type        = string
  description = <<-EOT
    If this value is specified, then a VPC will be created.
    This value sets the default private IP space for the created VPC.
    VPCs generated with this module automatically give Amazon supplied public addresses to ec2 instances via an internet gateway.
    Access to the ec2 instances is then controlled by the security group.
    WARNING: AWS reserves the first four IP addresses and the last IP address in any CIDR block for its own use (cumulatively).
    This means that every VPC has 5 IP addresses that cannot be assigned to subnets, and every subnet assigned has 5 IP addresses that cannot be used.
    If you attempt to generate a VPC that has no usable addresses you will get an "invalid CIDR" error from AWS.
    If you attempt to generate a subnet that uses one of the addresses reserved by AWS in the VPC's CIDR, you will get an "invalid CIDR" error from AWS.
  EOT
  default     = ""
}
variable "skip_vpc" {
  type        = bool
  description = "Skip vpc generation, use with care."
  default     = false
}
# subnet
variable "subnet_name" {
  type        = string
  description = <<-EOT
    The name of the subnet you would like to create or select.
    This is required.
    If you provide a cidr value, then this module will create a subnet with the given name.
    If you do not provide a cidr value, then this module will attempt to find a subnet with the given name.
    If you override the VPC creation, but not the subnet creation,
      this module will attempt to associate the created subnet to the VPC.
    If the subnet is not available within the VPC's default CIDR, this module will fail.
    If you override the creation of the VPC and the creation of the subnet,
      this module won't attempt to associate the subnet to the VPC.
  EOT
  default     = ""
}
variable "subnet_cidr" {
  type        = string
  description = <<-EOT
    The cidr of the private subnet you would like to create.
    This cidr must be within the IP bounds of the vpc_cidr.
    If this is specified, then a subnet will be created.
    If this isn't specified, then the module will attempt to find a subnet with the given name.
    WARNING: AWS reserves the first four IP addresses and the last IP address in any CIDR block for its own use (cumulatively).
    This means that every VPC has 5 IP addresses that cannot be assigned to subnets, and every subnet assigned has 5 IP addresses that cannot be used.
    If you attempt to generate a subnet that has no usable addresses you will get an "invalid CIDR" error from AWS.
    If you attempt to generate a subnet that uses one of the addresses reserved by AWS in the VPC's CIDR, you will get an "invalid CIDR" error from AWS.
  EOT
  default     = ""
}
variable "availability_zone" {
  type        = string
  description = <<-EOT
    The availability zone to create the subnet in.
    This is the name of the availability zone, not the AWS unique id.
    For example "us-east-1a" or "us-east-1b" not "use1-az1" or "use1-az2".
    This is required when creating a subnet, but not when selecting a subnet.
    Any servers created in this subnet will be created in this availability zone.
  EOT
  default     = ""
}
variable "skip_subnet" {
  type        = bool
  description = "Skip subnet generation, use with care."
  default     = false
}
# security group
variable "security_group_name" {
  type        = string
  description = <<-EOT
    The name of the ec2 security group to create or select.
    This is required.
    If you would like to create a security group please specify the type of security group you would like to create.
    The types are located in modules/security_group/types.tf.
  EOT
  default     = ""
}
variable "security_group_type" {
  type        = string
  description = <<-EOT
    The type of the ec2 security group to create.
    We provide opinionated options for the user to select from.
    Leave this blank if you would like to select a security group rather than generate one.
    The types are located in ./modules/security_group/types.tf.
    If specified, must be one of: specific, internal, egress, or public.
  EOT
  default     = ""
}
variable "security_group_ip" {
  type        = string
  description = <<-EOT
    When selecting the type of security group to create, you may need to specify an IP address.
    If no IP address is specified the module will attempt to discover and use your local IP address.
    It is a good idea to specify the IP where Terraform will be run to create servers.
  EOT
  default     = ""
}
variable "skip_security_group" {
  type        = bool
  description = "Skip security group generation, use with care."
  default     = false
}

# ssh key
variable "ssh_key_name" {
  type        = string
  description = <<-EOT
    The name of the ec2 ssh key pair to create or select.
    This is required.
    If you would like to create an ssh key pair, please specify the public_ssh_key.
    If the public_ssh_key variable is not specified, then this module will attempt to find an ssh key with the given name.
  EOT
  default     = ""
}
variable "public_ssh_key" {
  type        = string
  description = <<-EOT
    The contents of the public ssh key object to create.
    If this is specified, then an ssh key will be created.
    If this isn't specified, then the module will attempt to find an ssh key with the given name.
  EOT
  default     = ""
}
variable "skip_ssh" {
  type        = bool
  description = "Skip ssh key generation, use with care."
  default     = false
}