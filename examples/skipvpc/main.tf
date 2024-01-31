# generate ssh key only
module "this" {
  source              = "../../"
  owner               = "terraform-ci@suse.com"
  skip_vpc            = true
  skip_subnet         = true # without a vpc selected or created subnet can't be created
  skip_security_group = true # without a vpc selected of created security group can't be created
  public_ssh_key      = var.key
  ssh_key_name        = var.key_name
}
