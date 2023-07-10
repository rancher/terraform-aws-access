# this test generates objects generally needed for a new project which is on its own network
# this will generate a new subnet for your project with the given cidr (this must be an unused block from the vpc's cidr)
# this will generate a security group for your project's cidr
module "TestProject" {
  source              = "../../"
  owner               = "you@example.com"
  vpc_name            = "default" # select the default vpc
  subnet_name         = "test"
  subnet_cidr         = "10.1.1.0/24"
  security_group_name = "test"
  security_group_type = "egress"
  ssh_key_name        = "default" # select your ssh key
}
