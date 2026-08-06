terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.57.1"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1"
    }
    acme = {
      source  = "vancluever/acme"
      version = ">= 2.0"
    }
  }
}
