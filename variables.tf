# vpc
variable "vpc_use_strategy" {
  type        = string
  description = <<-EOT
    Strategy for using vpc resources:
      'skip' to disable,
      'select' to use existing,
      or 'create' to generate new vpc resources.
    VPC CIDRs are no longer required, and will be generated automatically.
    When selecting a vpc, the vpc_name must be provided and a vpc that has a tag "Name" with the given name must exist.
    When skipping a vpc, the subnet, security group, and load balancer will also be skipped (automatically).
  EOT
  default     = "create"
  validation {
    condition     = contains(["skip", "select", "create"], var.vpc_use_strategy)
    error_message = "The vpc_use_strategy value must be one of 'skip', 'select', or 'create'."
  }
}
variable "vpc_name" {
  type        = string
  description = <<-EOT
    The name of the VPC to create or select.
  EOT
  default     = "default"
}
variable "vpc_type" {
  type        = string
  description = <<-EOT
    The type of CIDR block to use for the VPC.
    Options are:
      ipv4: Deploy an IPv4 only VPC.
      ipv6: Deploy an IPv6 Native VPC, IPv4 won't be compatible and changing to dualstack will require new VPC/subnets/load balancer/security groups.
      dualstack: Deploy a dualstack VPC, this will be native IPv4 with additional IPv6 support.
        dualstack doesn't enable using all IPv6 features, it simply deploys IPv6 addresses and enables IPv6 traffic.
        moving from dualstack to IPv6 will require new VPC/subnets/load balancer/security groups.
  EOT
  default     = "ipv4"
}
variable "vpc_zones" {
  type        = list(string)
  description = <<-EOT
    The availability zones to deploy subnets to within the VPC.
    The VPC should span these zones, this informs the subnet creation strategy.
    The default is to use the first availability zone found in the region.
    Only one subnet will be created per availability zone.
    This should be the name of the zone, not its id. eg. 'us-west-2a' not 'usw2-az2'.
  EOT
  default     = []
}
variable "vpc_public" {
  type        = bool
  description = <<-EOT
    Whether to assign a public IP address to instances using subnets.
    This is not an EIP, that should be handled at a different level, eg. when generating an ec2 instance.
  EOT
  default     = false
}
variable "vpc_cidr" {
  type = object({
    ipv4 = string
    ipv6 = string
  })
  description = <<-EOT
    The CIDR block to use for the VPC.
  EOT
  default = {
    ipv4 = "10.0.0.0/16"  # must be a /16 block or smaller
    ipv6 = "fc00:0:0:/56" # must be a /56 block
  }
}

# subnet
variable "subnet_use_strategy" {
  type        = string
  description = <<-EOT
    Strategy for using subnet resources:
      'skip' to disable,
      'select' to use existing,
      or 'create' to generate new subnet resources.
    The default is 'create', which requires a subnet_name and subnet_cidr to be provided.
    When selecting a subnet, the subnet_name must be provided and a subnet with the tag "Name" with the given name must exist.
    When skipping a subnet, the security group and load balancer will also be skipped (automatically).
  EOT
  default     = "create"
  validation {
    condition     = contains(["skip", "select", "create"], var.subnet_use_strategy)
    error_message = "The subnet_use_strategy value must be one of 'skip', 'select', or 'create'."
  }
}

# security group
variable "security_group_use_strategy" {
  type        = string
  description = <<-EOT
    Strategy for using security group resources:
      'skip' to disable,
      'select' to use existing,
      or 'create' to generate new security group resources.
    The default is 'create'.
    When selecting a security group, the security_group_name must be provided and a security group with the given name must exist.
    When skipping a security group, the load balancer will also be skipped (automatically).
  EOT
  default     = "create"
  validation {
    condition     = contains(["skip", "select", "create"], var.security_group_use_strategy)
    error_message = "The security_group_use_strategy value must be one of 'skip', 'select', or 'create'."
  }
}
variable "security_group_name" {
  type        = string
  description = <<-EOT
    The name of the ec2 security group to create or select.
    When choosing the "create" or "select" strategy, this is required.
    When choosing the "skip" strategy, this is ignored.
    When selecting a security group, the security_group_name must be provided and a security group with the given name must exist.
    When creating a security group, the name will be used to tag the resource, and security_group_type is required.
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
    If specified, must be one of: project, egress, or public.
  EOT
  default     = "project"
  validation {
    condition     = contains(["project", "egress", "public"], var.security_group_type)
    error_message = "The security_group_type value must be one of 'project', 'egress', or 'public'."
  }
}

# load balancer
variable "load_balancer_use_strategy" {
  type        = string
  description = <<-EOT
    Strategy for using load balancer resources:
      'skip' to disable,
      'select' to use existing,
      or 'create' to generate new load balancer resources.
    The default is 'create'.
    When selecting a load balancer, the load_balancer_name must be provided and a load balancer with the "Name" tag must exist.
    When skipping a load balancer, the domain will also be skipped (automatically).
  EOT
  default     = "create"
  validation {
    condition     = contains(["skip", "select", "create"], var.load_balancer_use_strategy)
    error_message = "The load_balancer_use_strategy value must be one of 'skip', 'select', or 'create'."
  }
}
variable "load_balancer_name" {
  type        = string
  description = <<-EOT
    The name of the Load Balancer, there must be a 'Name' tag on it to be found.
    When generating a load balancer, this will be added as a tag to the resource.
    This tag is how we will find it again in the future.
    If a domain and a load balancer name is given, we will create a domain record pointing to the load balancer.
  EOT
  default     = ""
}
variable "load_balancer_access_cidrs" {
  type = map(object({
    port        = number
    cidrs       = list(string)
    protocol    = string
    target_name = string
  }))
  description = <<-EOT
    A map of access information objects.
    The port is the port to expose on the load balancer.
    The cidrs is a list of external cidr blocks to allow access to the load balancer.
    The protocol is the network protocol to expose on, this can be 'udp' or 'tcp'.
    The target_name must be unique per region per account,
      can have a maximum of 32 characters,
      must contain only alphanumeric characters or hyphens,
      and must not begin or end with a hyphen.
    Example:
    {
      test = {
        port        = 443
        cidrs       = ["1.1.1.1/32"]
        protocol    = "tcp"
        target_name = "test-target-123abc"
      }
    }
  EOT
  default     = null
}

# domain
variable "domain_use_strategy" {
  type        = string
  description = <<-EOT
    Strategy for using domain resources:
      'skip' to disable,
      'select' to use existing,
      or 'create' to generate new domain resources.
    The default is 'create', which requires a domain name to be provided.
    When selecting a domain, the domain must be provided and a domain with the matching name must exist.
    When adding a domain, it will be attached to all load balancer ports with a certificate for secure access.
  EOT
  default     = "create"
  validation {
    condition     = contains(["skip", "select", "create"], var.domain_use_strategy)
    error_message = "The domain_use_strategy value must be one of 'skip', 'select', or 'create'."
  }
}
variable "domain" {
  type        = string
  description = <<-EOT
    The domain name to retrieve or create.
    Part of creating the domain is assigning it to the load balancer and generating a tls certificate.
    This should enable secure connections for your project.
    To make use of this feature, you must generate load balancer target group associations in other further stages.
    We output the arn of the load balancer for this purpose.
  EOT
  default     = ""
}
variable "cert_use_strategy" {
  type        = string
  description = <<-EOT
    Strategy for using certs:
     'skip' to skip,
     'select' to select an existing cert,
     or 'create' to generate a new cert.
    The cert created will be for the domain specified, it will be saved in an iam_server_certificate.
    You can add the certificate to the server or use it when configuring services.
    To select a cert, it must have a name prefixed with the domain specified.
  EOT
  default     = "skip"
}
