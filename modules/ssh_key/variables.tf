# all descriptions should use heredoc blocks
variable "name" {
  type        = string
  description = <<-EOT
    The name of the ssh key to find or create.
  EOT
}
variable "public_key" {
  type        = string
  description = <<-EOT
    The contents of the public key to create.
    If this is specified, then a public key object will be created.
  EOT
  default     = ""
}
variable "owner" {
  type        = string
  description = "The owner to tag the public key with after creation."
  default     = "terraform"
}
