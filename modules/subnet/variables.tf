variable "use" {
  type        = string
  description = <<-EOT
    Strategy for using subnet resources:
      'select' to use existing,
      or 'create' to generate new subnet resources.
    When selecting a subnet, the name must be provided and a subnet with the matching tag Name must exist.
  EOT
}
variable "vpc_id" {
  type        = string
  description = <<-EOT
    The AWS unique id for the VPC which this subnet will be created in.
  EOT
}
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
  EOT
}
variable "availability_zone" {
  type        = string
  description = <<-EOT
    The availability zone to create the subnet in.
    This is the name of the availability zone, not the AWS unique id.
    For example "us-east-1a" or "us-east-1b" not "use1-az1" or "use1-az2".
  EOT
}
variable "public" {
  type        = bool
  description = <<-EOT
    Set this to true to enable the subnet to have public IP addresses.
    When this is false you will need to use EIP to assign public IP addresses to servers.
    WARNING! there is a 5 IP address limit for EIPs per region.
  EOT
}