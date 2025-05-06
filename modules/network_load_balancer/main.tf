locals {
  use               = var.use
  name              = var.name
  vpc_id            = var.vpc_id
  type              = var.vpc_type
  security_group_id = var.security_group_id
  subnets           = var.subnets
  access_info       = (var.access_info == null ? {} : var.access_info)
  create            = (local.use == "create" ? 1 : 0)
  select            = (local.use == "select" ? 1 : 0)
  ipv4ds            = ((local.type == "ipv4" || local.type == "dualstack") ? local.create : 0)
  ipv6ds            = ((local.type == "ipv6" || local.type == "dualstack") ? local.create : 0)
  public_ips = (local.ipv4ds == 1 ?
    [for e in aws_eip.created : e.public_ip if can(e.public_ip)] :
    [for s in local.subnets : cidrhost(s.cidrs.ipv6, -2) if can(cidrhost(s.cidrs.ipv6, -2))]
  )

  access_info_cidrs_length = [
    for i in range(length(local.access_info)) :
    length(local.access_info[keys(local.access_info)[i]].cidrs)
  ] # [1,1,2,2,1]

  access_info_cidrs_matrix = merge([
    for ia in range(length(local.access_info)) :
    {
      for ib in range(local.access_info_cidrs_length[ia]) :
      "${keys(local.access_info)[ia]}-${ib}" => {
        port        = local.access_info[keys(local.access_info)[ia]].port
        ip_family   = local.access_info[keys(local.access_info)[ia]].ip_family
        cidr        = local.access_info[keys(local.access_info)[ia]].cidrs[ib]
        protocol    = local.access_info[keys(local.access_info)[ia]].protocol
        target_name = local.access_info[keys(local.access_info)[ia]].target_name
      }
    }
  ]...)
  # Access info example
  # test = {
  #   port        = 443
  #   ip_family   = "ipv4"
  #   cidrs       = ["1.1.1.1/32"]
  #   protocol    = "tcp"
  #   target_name = "test-test-123abc"
  # }
}

data "aws_lb" "selected" {
  count = local.select
  tags = {
    Name = local.name
  }
}

resource "aws_eip" "created" {
  for_each                  = (local.ipv4ds == 1 ? local.subnets : {})
  domain                    = "vpc"
  associate_with_private_ip = cidrhost(each.value.cidrs.ipv4, -2)
  tags = {
    Name = each.value.name
  }
}

resource "aws_security_group" "load_balancer" {
  count       = local.create
  name        = local.name
  description = "Security group for load balancer ${local.name}"
  vpc_id      = local.vpc_id
  tags = {
    Name = local.name
  }
}

resource "aws_vpc_security_group_ingress_rule" "external_ingress" {
  for_each          = (local.create == 1 ? local.access_info_cidrs_matrix : {})
  security_group_id = aws_security_group.load_balancer[0].id
  from_port         = each.value.port
  to_port           = each.value.port
  ip_protocol       = each.value.protocol
  cidr_ipv4         = (each.value.ip_family != "ipv6" ? each.value.cidr : null)
  cidr_ipv6         = (each.value.ip_family == "ipv6" ? each.value.cidr : null)
}

# allows the project to ingress the load balancer
resource "aws_vpc_security_group_ingress_rule" "project_ingress_loadbalancer" {
  depends_on = [
    aws_security_group.load_balancer,
  ]
  referenced_security_group_id = local.security_group_id
  security_group_id            = aws_security_group.load_balancer[0].id
  ip_protocol                  = "-1"
}

resource "aws_lb" "new" {
  count = local.create
  depends_on = [
    aws_eip.created,
  ]
  name                             = local.name
  internal                         = false
  load_balancer_type               = "network"
  security_groups                  = [aws_security_group.load_balancer[0].id]
  enable_cross_zone_load_balancing = true # cross zone load balancing is necessary for HA
  dynamic "subnet_mapping" {
    for_each = local.subnets
    content {
      subnet_id = subnet_mapping.value.id
      allocation_id = (
        local.ipv4ds == 1 && can(aws_eip.created[subnet_mapping.key].id) ?
        aws_eip.created[subnet_mapping.key].id : # map EIP with attached ipv4 private address
        null                                     # don't use allocation_id when ipv6 only
      )
      ipv6_address = (
        local.ipv6ds == 1 && can(cidrhost(subnet_mapping.value.cidrs.ipv6, -2)) ? # map ipv6 address directly
        cidrhost(subnet_mapping.value.cidrs.ipv6, -2) :
        null # don't use ipv6_address unless ipv6 is enabled
      )
    }
  }
  tags = {
    Name = local.name
  }
}

resource "aws_lb_target_group" "created" {
  depends_on = [
    aws_lb.new,
  ]
  for_each        = (local.create == 1 ? local.access_info : {})
  name            = substr(each.value.target_name, 0, 32)
  port            = each.value.port
  protocol        = upper(each.value.protocol)
  target_type     = "instance"
  ip_address_type = (each.value.ip_family == "ipv6" ? "ipv6" : "ipv4")
  vpc_id          = local.vpc_id
  tags = {
    Name = each.value.target_name
  }
  health_check {
    enabled  = true
    port     = each.value.port
    protocol = upper(each.value.protocol)
  }
}

resource "aws_lb_listener" "created" {
  depends_on = [
    aws_lb.new,
  ]
  for_each          = (local.create == 1 ? local.access_info : {})
  load_balancer_arn = aws_lb.new[0].arn
  port              = each.value.port
  protocol          = upper(each.value.protocol)
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.created[each.key].arn
  }
}
