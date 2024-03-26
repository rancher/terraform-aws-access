variable "name" {
  type        = string
  description = <<-EOT
    The name of the Load Balancer, there must be a 'Name' tag on it to be found.
    When generating a load balancer, this will be added as a tag to the resource.
    This tag is how we will find it again in the future.
  EOT
}
variable "owner" {
  type        = string
  description = <<-EOT
    The owner of the Load Balancer, this is used as refence in the AWS console.
    When generating a load balancer, this will be added as a tag to the resource.
    This tag is how we will find it again in the future.
  EOT
}
variable "create" {
  type        = bool
  description = "Set to false to select a load balancer rather than creating one."
}
variable "security_group_id" {
  type        = string
  description = <<-EOT
    The security group id to attach to the Load Balancer.
  EOT
}
variable "subnet_id" {
  type        = string
  description = <<-EOT
    The subnet id to attach to the Load Balancer.
  EOT
}
variable "vpc_id" {
  type        = string
  description = <<-EOT
    The VPC id to deploy the load balancer in.
  EOT
}
