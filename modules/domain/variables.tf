variable "use" {
  type        = string
  description = <<-EOT
    Strategy for using domain resources:
      'select' to use existing,
      or 'create' to generate new domain resources.
    The default is 'create'.
    When selecting a domain, the content must be provided and a domain with the matching address must exist.
    We will extract the zone from the content, this module does not create zones.
  EOT
}

variable "cert_use_strategy" {
  type        = string
  description = <<-EOT
    Strategy for using cert resource:
      'skip' to not create a certificate,
      'select' to use existing,
      or 'create' to generate new resource.
    The default is 'skip'.
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

variable "ip" {
  type        = string
  description = <<-EOT
    The ip address to attach to the domain.
    When selecting a domain we won't generate any domain objects, we won't create a cert.
  EOT
  default     = ""
}
