
variable "name" {
  type        = string
  description = <<-EOT
    The name of the security group to find or create.
    Required.
  EOT
}

# only used when generating a security group
variable "type" {
  type        = string
  description = <<-EOT
    The designation from the types.tf of opinionated options to use.
    If this value is specified the assumption is that the security group is being generated.
    If this value isn't specified the assumption is that the security group is being found.
  EOT
  default     = ""
}
variable "owner" {
  type        = string
  description = <<-EOT
    The owner to tag the security group with if generated.
    Not necessary if the security group is being found.
  EOT
  default     = ""
}
variable "ip" {
  type        = string
  description = <<-EOT
    The public IP addess to allow ingress from external WAN to the servers in the security group.
    Not necessary if the security group is being found.
  EOT
  default     = ""
}
variable "cidr" {
  type        = string
  description = <<-EOT
    The cidr of the internal subnet to allow servers access to when generating the security group.
    Not necessary if the security group is being found.
  EOT
  default     = ""
}
variable "vpc_id" {
  type        = string
  description = <<-EOT
    The id of the vpc to use when generating the security group.
    Not necessary if the security group is being found.
  EOT
  default     = ""
}