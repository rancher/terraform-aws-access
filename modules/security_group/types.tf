locals {
  types = {
    none = {
      # this will be selected only if no type is given
      # this will not create a security group, it will select one based on the name given
      specific_ip_ingress = false
      specific_ip_egress  = false
      internal_ingress    = false
      internal_egress     = false
      project_ingress     = false
      project_egress      = false
      public_ingress      = false
      public_egress       = false
    }
    specific = {
      # allow all ingress and egress, but only from specified ip
      # this will require users to figure out how to update and install packages without public internet access
      # the server will only be able to egress to specified ip
      # specified ip can be outside the vpc
      specific_ip_ingress = true
      specific_ip_egress  = true
      internal_ingress    = false
      internal_egress     = false
      project_ingress     = false
      project_egress      = false
      public_ingress      = false
      public_egress       = false
    }
    internal = {
      # allow all ingress and egress, but only from specified ip and cidr
      # this will require users to figure out how to update and install packages without public internet access
      # the server will only be able to egress to specified ip or cidr
      # specified ip can be outside the vpc, the cidr must be inside the vpc
      specific_ip_ingress = true
      specific_ip_egress  = true
      internal_ingress    = true
      internal_egress     = true
      project_ingress     = false
      project_egress      = false
      public_ingress      = false
      public_egress       = false
    }
    project = {
      # allow all ingress and egress, but only from specified ip, cidr, and VPC cidr
      # this will require users to figure out how to update and install packages without public internet access
      # the server will only be able to egress to specified ip, or any server on a subnet within the VPC internal CIDR
      # specified ip can be outside the vpc, the cidr must be inside the vpc, and the vpc cidr must match the vpc
      specific_ip_ingress = true
      specific_ip_egress  = true
      internal_ingress    = true
      internal_egress     = true
      project_ingress     = true
      project_egress      = true
      public_ingress      = false
      public_egress       = false
    }
    egress = {
      # allow all ingress and egress, but only from specified ip and vpc cidr
      # allow egress to public internet, this enables updates and package installs
      # the server will be able to initiate connections to anywhere
      # only specified ip and vpc cidr can initiate connections to the server
      # specified ip can be outside the vpc, the cidr must be inside the vpc, and the vpc cidr must match the vpc
      specific_ip_ingress = true
      specific_ip_egress  = true
      internal_ingress    = true
      internal_egress     = true
      project_ingress     = true
      project_egress      = true
      public_ingress      = false
      public_egress       = true
    }
    public = {
      # allow all ingress and egress, from anywhere
      # this is the least secure option
      specific_ip_ingress = true
      specific_ip_egress  = true
      internal_ingress    = true
      internal_egress     = true
      project_ingress     = true
      project_egress      = true
      public_ingress      = true
      public_egress       = true
    }
  }
}