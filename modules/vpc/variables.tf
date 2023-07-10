
variable "name" {
  type        = string
  description = <<-EOT
    The name of the VPC, there must be a 'Name' tag on it to be found.
  EOT
}
variable "cidr" {
  type        = string
  description = <<-EOT
    The cidr for the VPC to create.
    If this is specified a VPC will be created.
    If this isn't specified, then the module will attempt to find a VPC with the given name.
  EOT
}
