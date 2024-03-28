variable "use" {
  type        = string
  description = <<-EOT
    Strategy for using VPC resources:
      'select' to use existing,
      or 'create' to generate new VPC resources
    When selecting a VPC, the name must be provided and a VPC with the matching name must exist.
  EOT
}
variable "name" {
  type        = string
  description = <<-EOT
    The name of the VPC, there must be a 'Name' tag on it to be found.
    When generating a VPC, this will be added as a tag to the resource.
  EOT
}
variable "cidr" {
  type        = string
  description = <<-EOT
    The cidr for the VPC to create.
    This is not required when selecting an existing VPC.
  EOT
}
