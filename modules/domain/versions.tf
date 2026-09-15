terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.57.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.4.0"
    }
    acme = {
      source  = "vancluever/acme"
      version = ">= 2.0"
    }
  }
}
