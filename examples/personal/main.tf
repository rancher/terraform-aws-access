# this test generates objects generally considered personal
# this will generate a security group for your personal ip
# this will generate a ec2 key pair from a provided public key which you have the private key for (making it personal)
module "TestPersonal" {
  source              = "../../"
  owner               = "you@example.com"
  vpc_name            = "default" # select the default vpc
  subnet_name         = "default" # select the default subnet
  security_group_name = "you"
  security_group_type = "egress"
  ssh_key_name        = "you"
  ssh_key             = "ssh-abc yOur+key you@example.com"
}
