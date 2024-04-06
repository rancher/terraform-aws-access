variable "use" {
  type        = string
  description = <<-EOT
    Strategy for using load balancer resources:
      'select' to use existing,
      or 'create' to generate new load balancer resources.
    The default is 'create'.
    When selecting a load balancer, the name must be provided and a load balancer with the "Name" tag must exist.
    When selecting a load balancer the security group, subnet, and VPC arguments are ignored.
  EOT
}
variable "name" {
  type        = string
  description = <<-EOT
    The name of the Load Balancer, there must be a 'Name' tag on it to be found.
    When generating a load balancer, this will be added as a tag to the resource.
    This tag is how we will find it again in the future.
  EOT
}
variable "vpc_id" {
  type        = string
  description = <<-EOT
    The VPC id where the load balancer will be created.
  EOT
}
variable "security_group_id" {
  type        = string
  description = <<-EOT
    The security group id to attach to the Load Balancer.
  EOT
  default     = ""
}
variable "subnet_ids" {
  type        = list(string)
  description = <<-EOT
    The subnet ids to attach to the Load Balancer.
  EOT
  default     = []
}
variable "access_cidrs" {
  type        = map(list(string))
  description = <<-EOT
    A list of maps relating a port to a list of CIDRs that are allowed to access the load balancer external to the VPC.
    If this is not provided, no IP addresses will be allowed to access the load balancer externally.
    example: {"443" = ["1.1.1.1/32"]} would allow IP address 1.1.1.1 to access the load balancer on port 443.
  EOT
  default     = {}
}
