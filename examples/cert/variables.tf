variable "identifier" {
  type = string
}
# variable "domain_zone" {
#   type = string
#   description = "The domain zone to use for the domain record. eg. example.com for domain 'test.example.com'"
# }
variable "zone" {
  type        = string
  description = <<-EOT
    The domain to use as the zone for a generated domain name.
    This must already exist in route53 and be globally populated.
  EOT
}