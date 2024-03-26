variable "owner" {
  type        = string
  description = "The owner to tag the domain with after creation."
  default     = "terraform"
}

variable "create" {
  type        = bool
  description = <<-EOT
    Set to true to add a domain record.
  EOT
}

variable "content" {
  type        = string
  description = <<-EOT
    A prevetted unique domain name to use for the project.
    WARNING! Domains are unique and must be pre-vetted by the project owner.
    WARNING! After a domain is generated the account owner must verify their email address within 10 days or it will be deleted.
  EOT
}

variable "alias" {
  type        = string
  description = <<-EOT
    An undesireable pre-generated domain name assigned to the project (for instance, from the creation of a network load balancer).
  EOT
  default     = ""
}

variable "zone" {
  type        = string
  description = <<-EOT
    Setting this will create a new zone with the given name.
    The zone to add the domain to.
    If this is not set we will attempt to find the zone based on the domain name.
  EOT
  default     = ""
}
