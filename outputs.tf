output "vpc" {
  value = (can(module.vpc[0].vpc) ? {
    id                  = module.vpc[0].vpc.id
    arn                 = module.vpc[0].vpc.arn
    cidr_block          = module.vpc[0].vpc.cidr_block
    ipv6_cidr_block     = module.vpc[0].vpc.ipv6_cidr_block
    main_route_table_id = module.vpc[0].vpc.main_route_table_id
    tags_all            = module.vpc[0].vpc.tags_all
    } : {
    id                  = ""
    arn                 = ""
    cidr_block          = ""
    ipv6_cidr_block     = ""
    main_route_table_id = ""
    tags_all            = tomap({ "" = "" })
  })
  description = <<-EOT
    The VPC object from AWS.
  EOT
}

output "subnet" {
  value = (can(module.subnet[0].subnet) ? {
    id                   = module.subnet[0].subnet.id
    arn                  = module.subnet[0].subnet.arn
    availability_zone    = module.subnet[0].subnet.availability_zone
    availability_zone_id = module.subnet[0].subnet.availability_zone_id
    cidr_block           = module.subnet[0].subnet.cidr_block
    ipv6_cidr_block      = module.subnet[0].subnet.ipv6_cidr_block
    vpc_id               = module.subnet[0].subnet.vpc_id
    tags_all             = module.subnet[0].subnet.tags_all
    } : {
    # no object found, but output types are normal
    id                   = ""
    arn                  = ""
    availability_zone    = ""
    availability_zone_id = ""
    cidr_block           = ""
    ipv6_cidr_block      = ""
    vpc_id               = ""
    tags_all             = tomap({ "" = "" })
  })
  description = <<-EOT
    The subnet object from AWS.
  EOT
}

output "security_group" {
  value = (can(module.security_group[0].security_group) ? {
    id       = module.security_group[0].security_group.id
    arn      = module.security_group[0].security_group.arn
    name     = module.security_group[0].security_group.name
    vpc_id   = module.security_group[0].security_group.vpc_id
    tags_all = module.security_group[0].security_group.tags_all
    } : {
    # no object found, but output types are normal
    id       = ""
    arn      = ""
    name     = ""
    vpc_id   = ""
    tags_all = tomap({ "" = "" })
  })
  description = <<-EOT
    The security group object from AWS.
  EOT
}

output "load_balancer" {
  value = (can(module.network_load_balancer[0].load_balancer) ? {
    id              = module.network_load_balancer[0].load_balancer.id
    arn             = module.network_load_balancer[0].load_balancer.arn
    dns_name        = module.network_load_balancer[0].load_balancer.dns_name
    zone_id         = module.network_load_balancer[0].load_balancer.zone_id
    security_groups = module.network_load_balancer[0].load_balancer.security_groups
    subnets         = module.network_load_balancer[0].load_balancer.subnets
    tags_all        = module.network_load_balancer[0].load_balancer.tags_all
    } : {
    # no object found, but output types are normal
    id              = ""
    arn             = ""
    dns_name        = ""
    zone_id         = ""
    security_groups = []
    subnets         = []
    tags_all        = tomap({ "" = "" })
  })
  description = <<-EOT
    The load balancer object from AWS.
  EOT
}

output "domain" {
  value = (can(module.domain[0].domain) ? {
    id      = module.domain[0].domain.id
    name    = module.domain[0].domain.name
    zone_id = module.domain[0].domain.zone_id
    type    = module.domain[0].domain.type
    records = module.domain[0].domain.records
    } : {
    # no object found, but output types are normal
    id      = ""
    name    = ""
    zone_id = ""
    type    = ""
    records = []
  })
  description = <<-EOT
    The domain object from AWS.
  EOT
}

output "certificate" {
  value = (can(module.domain[0].certificate) ? {
    id          = module.domain[0].certificate.id
    arn         = module.domain[0].certificate.arn
    name        = module.domain[0].certificate.name
    expiration  = module.domain[0].certificate.expiration
    upload_date = module.domain[0].certificate.upload_date
    tags_all    = module.domain[0].certificate.tags_all
    } : {
    # no object found, but output types are normal
    id          = ""
    arn         = ""
    name        = ""
    expiration  = ""
    upload_date = ""
    tags_all    = tomap({ "" = "" })
  })
  description = <<-EOT
    The certificate object from AWS.
  EOT
}
