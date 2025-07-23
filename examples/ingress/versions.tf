terraform {
  required_version = ">= 1.5.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = ">= 2.5"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.11"
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
