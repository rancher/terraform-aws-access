module "TestOverride" {
  source              = "../../"
  vpc_name            = "default"
  subnet_name         = "default"
  security_group_name = var.security_group_name
  ssh_key_name        = var.key_name # I don't normally recommend using variables in root modules, but it allows tests to supply their own key
  # A lot of troubleshooting during critical times can be saved by hard coding variables in root modules
  # root modules should be secured properly (including the state), and should represent your running infrastructure
}
