# this is given for reference, in most cases you will want to set the region using environment variables
# provider "aws" {
#   region = "us-west-1"
# }

# AWS reserves the first four IP addresses and the last IP address in any CIDR block for its own use (cumulatively)
module "TestBasic" {
  source              = "../../"
  owner               = "terraform-ci@suse.com"
  vpc_name            = "terraform-aws-access-test-basic"
  vpc_cidr            = "10.0.255.0/24" # gives 256 usable addresses from .1 to .254, but AWS reserves .1 to .4 and .255, leaving .5 to .254
  subnet_name         = "terraform-aws-access-test-basic"
  subnet_cidr         = "10.0.255.224/28" # gives 14 usable addresses from .225 to .238, but AWS reserves .225 to .227 and .238, leaving .227 to .237
  availability_zone   = "us-west-1b"      # check what availability zones are available in your region before setting this
  security_group_name = "terraform-aws-access-test-basic"
  security_group_type = "egress"
  security_group_ip   = chomp(var.ip)
  public_ssh_key      = var.key      # I don't normally recommend this, but it allows tests to supply their own key
  ssh_key_name        = var.key_name # A lot of troubleshooting during critical times can be saved by hard coding variables in root modules
  # root modules should be secured properly (including the state), and should represent your running infrastructure
}
