output "vpc" {
  value = {
    id                  = can(module.vpc[0].id) ? module.vpc[0].id : ""
    arn                 = can(module.vpc[0].arn) ? module.vpc[0].arn : ""
    ipv4_cidr           = can(module.vpc[0].ipv4) ? module.vpc[0].ipv4 : ""
    ipv6_cidr           = can(module.vpc[0].ipv6) ? module.vpc[0].ipv6 : ""
    main_route_table_id = can(module.vpc[0].main_route_table_id) ? module.vpc[0].main_route_table_id : ""
    tags                = can(module.vpc[0].tags) ? module.vpc[0].tags : tomap({ "" = "" })
  }
  description = <<-EOT
    The VPC object from AWS.
  EOT
}

output "subnets" {
  value = { for i in range(length(module.subnet)) :
    module.subnet[keys(module.subnet)[i]].name => {
      id                   = module.subnet[keys(module.subnet)[i]].id
      arn                  = module.subnet[keys(module.subnet)[i]].arn
      availability_zone    = module.subnet[keys(module.subnet)[i]].availability_zone
      availability_zone_id = module.subnet[keys(module.subnet)[i]].availability_zone_id
      cidrs = {
        ipv4 = module.subnet[keys(module.subnet)[i]].cidrs.ipv4
        ipv6 = module.subnet[keys(module.subnet)[i]].cidrs.ipv6
      }
      vpc_id = module.vpc[0].id
      tags   = module.subnet[keys(module.subnet)[i]].tags
    }
  }
  description = <<-EOT
    The subnet objects from AWS.
    This can be used to provision ec2 instances.
  EOT
}

output "security_group" {
  value = {
    id       = can(module.project_security_group[0].security_group.id) ? module.project_security_group[0].security_group.id : ""
    arn      = can(module.project_security_group[0].security_group.arn) ? module.project_security_group[0].security_group.arn : ""
    name     = can(module.project_security_group[0].security_group.name) ? module.project_security_group[0].security_group.name : ""
    vpc_id   = can(module.project_security_group[0].security_group.vpc_id) ? module.project_security_group[0].security_group.vpc_id : ""
    tags_all = can(module.project_security_group[0].security_group.tags_all) ? module.project_security_group[0].security_group.tags_all : tomap({ "" = "" })
  }
  description = <<-EOT
    The security group object from AWS.
    This is the project level security group,
    this should be common among all servers and objects in the project.
    This can be helpful to make sure that all servers in the same vpc can talk to each other.
  EOT
}

output "load_balancer" {
  value = {
    id              = can(module.network_load_balancer[0].load_balancer.id) ? module.network_load_balancer[0].load_balancer.id : ""
    arn             = can(module.network_load_balancer[0].load_balancer.arn) ? module.network_load_balancer[0].load_balancer.arn : ""
    dns_name        = can(module.network_load_balancer[0].load_balancer.dns_name) ? module.network_load_balancer[0].load_balancer.dns_name : ""
    zone_id         = can(module.network_load_balancer[0].load_balancer.zone_id) ? module.network_load_balancer[0].load_balancer.zone_id : ""
    security_groups = can(module.network_load_balancer[0].load_balancer.security_groups) ? module.network_load_balancer[0].load_balancer.security_groups : []
    subnets         = can(module.network_load_balancer[0].load_balancer.subnets) ? module.network_load_balancer[0].load_balancer.subnets : []
    public_ips      = can(module.network_load_balancer[0].public_ips) ? module.network_load_balancer[0].public_ips : []
    tags_all        = can(module.network_load_balancer[0].load_balancer.tags_all) ? module.network_load_balancer[0].load_balancer.tags_all : tomap({ "" = "" })
  }
  description = <<-EOT
    The load balancer object from AWS.
    When generated, this can be helpful to set up indirect access to servers.
    This is a network load balancer with either UDP or TCP protocol.
    As such, it doesn't encrypt or decrypt data and TLS must be handled at the server level.
  EOT
}

output "load_balancer_target_groups" {
  value = [for i in range(length((can(module.network_load_balancer[0].target_groups) ? module.network_load_balancer[0].target_groups : {}))) :
    {
      id       = (can(module.network_load_balancer[0].target_groups[i].id) ? module.network_load_balancer[0].target_groups[i].id : "")
      arn      = (can(module.network_load_balancer[0].target_groups[i].arn) ? module.network_load_balancer[0].target_groups[i].arn : "")
      name     = (can(module.network_load_balancer[0].target_groups[i].name) ? module.network_load_balancer[0].target_groups[i].name : "")
      port     = (can(module.network_load_balancer[0].target_groups[i].port) ? module.network_load_balancer[0].target_groups[i].port : "")
      protocol = (can(module.network_load_balancer[0].target_groups[i].protocol) ? module.network_load_balancer[0].target_groups[i].protocol : "")
      tags_all = (can(module.network_load_balancer[0].target_groups[i].tags_all) ? module.network_load_balancer[0].target_groups[i].tags_all : tomap({ "" = "" }))
    }
  ]
  description = <<-EOT
    The load balancer target groups from AWS.
    When generated, this can be helpful to set up indirect access to servers.
    To attach servers, use the target_group_attachment resource.
  EOT
}

output "domain" {
  value = {
    id      = (can(module.domain[0].domain.id) ? module.domain[0].domain.id : "")
    name    = (can(module.domain[0].domain.name) ? module.domain[0].domain.name : "")
    zone_id = (can(module.domain[0].domain.zone_id) ? module.domain[0].domain.zone_id : "")
    type    = (can(module.domain[0].domain.type) ? module.domain[0].domain.type : "")
    records = (can(module.domain[0].domain.records) ? module.domain[0].domain.records : [])
  }
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
    key_id      = module.domain[0].certificate.key_id
    tags_all    = module.domain[0].certificate.tags_all
    } : {
    # no object found, but output types are normal
    id          = ""
    arn         = ""
    name        = ""
    expiration  = ""
    upload_date = ""
    key_id      = ""
    tags_all    = tomap({ "" = "" })
  })
  description = <<-EOT
    The certificate object from AWS.
    When generating a domain, a valid TLS certificate is also generated.
    This is helpful for servers and applications to import for securing transfer.
  EOT
}

output "subnet_map" {
  value = local.subnet_map
}
