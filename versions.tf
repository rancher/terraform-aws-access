terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.11"
    }
    acme = {
      source  = "vancluever/acme"
      version = ">= 2.0"
    }
  }
}
# provider "acme" {
#   server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
# }
