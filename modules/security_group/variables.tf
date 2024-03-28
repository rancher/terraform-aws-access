variable "use" {
  type        = string
  description = <<-EOT
    Strategy for using security group resources:
      'select' to use existing,
      or 'create' to generate new security group resources.
    When selecting a security group, the name must be provided and a security group with the matching tag Name must exist.
  EOT
}
variable "name" {
  type        = string
  description = <<-EOT
    The name of the security group to find or create.
  EOT
}
variable "type" {
  type        = string
  description = <<-EOT
    The designation from the types.tf of opinionated options to use.
    Not necessary if the security group is being selected.
  EOT
  default     = "none"
}
variable "vpc_id" {
  type        = string
  description = <<-EOT
    The id of the vpc to use when generating the security group.
    Not necessary if the security group is being selected.
  EOT
  default     = ""
}
variable "vpc_cidr" {
  type        = string
  description = <<-EOT
    The CIDR of the VPC, used to allow ingress from the VPC to the servers in the security group.
    Not necessary if the security group is being selected.
  EOT
  default     = ""
}
