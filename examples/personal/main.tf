# this test generates objects generally considered personal
# this will generate a security group for your personal ip
# this will generate a ec2 key pair from a provided public key which you have the private key for (making it personal)
module "TestPersonal" {
  source              = "../../"
  owner               = "terraform-ci@suse.com" # update this to your email or a group email, the resources will be tagged with this
  vpc_name            = "default"               # select the default vpc
  subnet_name         = "default"               # select the default subnet
  security_group_name = "terraform-aws-access-test-personal"
  security_group_type = "egress"
  public_ssh_key      = var.key      # I don't normally recommend this, but it allows tests to supply their own key
  ssh_key_name        = var.key_name # A lot of troubleshooting during critical times can be saved by hard coding variables in root modules
  # root modules should be secured properly (including the state), and should represent your running infrastructure
}
