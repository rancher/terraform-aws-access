locals {
  identifier = "skipssh"
}
# generate vpc, subnet, and security group, skip ssh keypair
module "this" {
  source              = "../../"
  owner               = "terraform-ci@suse.com"
  vpc_name            = "terraform-aws-access-${local.identifier}"
  vpc_cidr            = "10.0.255.0/24" # gives 256 usable addresses from .1 to .254, but AWS reserves .1 to .4 and .255, leaving .5 to .254
  subnet_name         = "terraform-aws-access-${local.identifier}"
  subnet_cidr         = "10.0.255.224/28" # gives 14 usable addresses from .225 to .238, but AWS reserves .225 to .227 and .238, leaving .227 to .237
  availability_zone   = "us-west-1b"      # check what availability zones are available in your region before setting this
  security_group_name = "terraform-aws-access-test-${local.identifier}"
  security_group_type = "egress"
  skip_ssh            = true
}
