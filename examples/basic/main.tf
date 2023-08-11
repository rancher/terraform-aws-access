
module "TestBasic" {
  source              = "../../"
  owner               = "terraform-ci@suse.com"
  vpc_name            = "terraform-aws-access-test-basic"
  vpc_cidr            = "10.0.0.0/16"
  subnet_name         = "terraform-aws-access-test-basic"
  subnet_cidr         = "10.0.0.0/24"
  security_group_name = "terraform-aws-access-test-basic"
  security_group_type = "egress"
  public_ssh_key      = var.key      # I don't normally recommend this, but it allows tests to supply their own key
  ssh_key_name        = var.key_name # A lot of troubleshooting during critical times can be saved by hard coding variables in root modules
  # root modules should be secured properly (including the state), and should represent your running infrastructure
}
