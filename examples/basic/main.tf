
module "TestBasic" {
  source              = "../../"
  owner               = "you@example.com"
  vpc_name            = "test"
  vpc_cidr            = "10.0.0.0/16"
  subnet_name         = "test"
  subnet_cidr         = "10.0.1.0/24"
  security_group_name = "test"
  security_group_type = "egress"
  ssh_key_name        = "you@example.com"
  public_ssh_key      = "ssh-type your+public+ssh+key+here you@example.com"
}
