# this test generates objects generally needed for a new project which is on its own network
# this will generate a new subnet for your project with the given cidr (this must be an unused block from the vpc's cidr)
# this will generate a security group for your project's cidr
module "TestProject" {
  source              = "../../"
  owner               = "terraform-ci@suse.com"
  vpc_name            = "default" # select the default vpc
  subnet_name         = "terraform-aws-access-test-project"
  subnet_cidr         = "172.31.254.0/24" # this must be an unused block from the vpc's cidr
  security_group_name = "terraform-aws-access-test-project"
  security_group_type = "egress"
  ssh_key_name        = var.key_name # I don't normally recommend using variables in a root module, but it allows tests to supply their own key
  # A lot of troubleshooting during critical times can be saved by hard coding variables in root modules
  # root modules should be secured properly (including the state), and should represent your running infrastructure
}
