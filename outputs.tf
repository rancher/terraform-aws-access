output "vpc" {
  value = (length(module.vpc) > 0 ? {
    id                  = module.vpc[0].vpc.id
    arn                 = module.vpc[0].vpc.arn
    cidr_block          = module.vpc[0].vpc.cidr_block
    ipv6_cidr_block     = module.vpc[0].vpc.ipv6_cidr_block
    main_route_table_id = module.vpc[0].vpc.main_route_table_id
    tags                = module.vpc[0].vpc.tags
    } : {
    id                  = ""
    arn                 = ""
    cidr_block          = ""
    ipv6_cidr_block     = ""
    main_route_table_id = ""
    tags                = tomap({ "" = "" })
  })
  description = <<-EOT
    The VPC object from AWS.
  EOT
}

output "subnets" {
  value = (length(module.subnet) > 0 ? {
    for subnet in module.subnet : subnet.subnet.tags.Name => {
      id                   = subnet.subnet.id
      arn                  = subnet.subnet.arn
      availability_zone    = subnet.subnet.availability_zone
      availability_zone_id = subnet.subnet.availability_zone_id
      cidr_block           = subnet.subnet.cidr_block
      ipv6_cidr_block      = subnet.subnet.ipv6_cidr_block
      vpc_id               = subnet.subnet.vpc_id
      tags_all             = subnet.subnet.tags_all
    }
    } : { "empty" = {
      id                   = ""
      arn                  = ""
      availability_zone    = ""
      availability_zone_id = ""
      cidr_block           = ""
      ipv6_cidr_block      = ""
      vpc_id               = ""
      tags_all             = tomap({ "" = "" })
    }
  })
  description = <<-EOT
    The subnet objects from AWS.
    This can be used to provision ec2 instances.
  EOT
}

output "security_group" {
  value = (length(module.security_group) > 0 ? {
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
    This is the project level security group,
    this should be common among all servers and objects in the project.
    This can be helpful to make sure that all servers in the same vpc can talk to each other.
  EOT
}

output "load_balancer" {
  value = (length(module.network_load_balancer) > 0 ? {
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
    When generated, this can be helpful to set up indirect access to servers.
    This is a network load balancer with either UDP or TCP protocol.
    As such, it doesn't encrypt or decrypt data and TLS must be handled at the server level.
  EOT
}

output "load_balancer_target_groups" {
  value = (length(module.network_load_balancer) > 0 ? [
    for k, v in module.network_load_balancer[0].target_groups :
    {
      id          = v.id
      arn         = v.arn
      name_prefix = v.name_prefix
      port        = v.port
      protocol    = v.protocol
      tags_all    = v.tags_all
    }
    ] : [{
      id          = ""
      arn         = ""
      name_prefix = ""
      port        = ""
      protocol    = ""
      tags_all    = tomap({ "" = "" })
    }
    ]
  )
  description = <<-EOT
    The load balancer target groups from AWS.
    When generated, this can be helpful to set up indirect access to servers.
    To attach servers, use the target_group_attachment resource.
  EOT
}

output "domain" {
  value = (length(module.domain) > 0 ? {
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
    When generated, the domain is applied to the EIP created with the load balancer.
    This is helpful when you want to expose an application indirectly.
  EOT
}

output "certificate" {
  value = ((length(module.domain) > 0) ? {
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
    When generating a domain, a valid TLS certificate is also generated.
    This is helpful for servers and applications to import for securing transfer.
  EOT
}
