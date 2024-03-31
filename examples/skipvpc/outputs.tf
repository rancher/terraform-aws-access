output "vpc" {
  value = module.this.vpc
}
output "subnets" {
  value = module.this.subnets
}
output "security_group" {
  value = module.this.security_group
}
output "load_balancer" {
  value = module.this.load_balancer
}
output "domain" {
  value = module.this.domain
}
output "certificate" {
  value = module.this.certificate
}
