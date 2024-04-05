variable "identifier" {
  type = string
}
# variable "domain_zone" {
#   type = string
#   description = "The domain zone to use for the domain record. eg. example.com for domain 'test.example.com'"
# }
variable "domain" {
  type        = string
  description = <<-EOT
    The domain to use for the domain record. eg. 'test.example.com'.
    This example assumes that the zone already exists.
  EOT
}