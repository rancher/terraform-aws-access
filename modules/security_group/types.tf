locals {
  types = {
    none = {
      # this will be selected only if no type is given
      # basically no rules will be created
      project_egress  = false
      project_ingress = false
      public_egress   = false
      public_ingress  = false
    }
    project = {
      # this allows communication between servers in the project across regions
      project_egress  = true
      project_ingress = true
      public_egress   = false
      public_ingress  = false
    }
    egress = {
      # this allows communication between servers in the project and the public internet
      # you might want to use this for servers that need to download packages
      project_egress  = true
      project_ingress = true
      public_egress   = true
      public_ingress  = false
    }
    public = {
      # allow all ingress and egress, from anywhere
      # this is the least secure option
      project_egress  = true
      project_ingress = true
      public_egress   = true
      public_ingress  = true
    }
  }
}