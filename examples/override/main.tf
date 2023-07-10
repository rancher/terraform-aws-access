module "TestOverride" {
  source              = "../../"
  vpc_name            = "default"
  subnet_name         = "default"
  ssh_key_name        = "default"
  security_group_name = "default"
}
