
variable "name" {
  type        = string
  description = <<-EOT
    The name of the subnet to find or create.
  EOT
}
variable "cidr" {
  type        = string
  description = <<-EOT
    The cidr for the subnet to create.
    If this is specified a subnet will be created.
    If this isn't specified, then the module will attempt to find a subnet with the given name.
  EOT
  default     = ""
}
variable "vpc_id" {
  type        = string
  description = <<-EOT
    The AWS unique id for the VPC which this subnet will be created in.
  EOT
  default     = ""
}
variable "owner" {
  type        = string
  description = <<-EOT
    The owner to tag on the subnet when creating it.
  EOT
  default     = ""
}
variable "availability_zone" {
  type        = string
  description = <<-EOT
    The availability zone to create the subnet in.
    This is the name of the availability zone, not the AWS unique id.
    For example "us-east-1a" or "us-east-1b" not "use1-az1" or "use1-az2".
  EOT
  default     = ""
}
