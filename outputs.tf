output "vpc" {
  value = (can(module.vpc[0].vpc) ? {
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

output "subnet" {
  value = (can(module.subnet[0].subnet) ? {
    id                   = module.subnet[0].subnet.id
    arn                  = module.subnet[0].subnet.arn
    availability_zone    = module.subnet[0].subnet.availability_zone
    availability_zone_id = module.subnet[0].subnet.availability_zone_id
    cidr_block           = module.subnet[0].subnet.cidr_block
    ipv6_cidr_block      = module.subnet[0].subnet.ipv6_cidr_block
    vpc_id               = module.subnet[0].subnet.vpc_id
    tags                 = module.subnet[0].subnet.tags
    } : {
    # no object found, but output types are normal
    id                   = ""
    arn                  = ""
    availability_zone    = ""
    availability_zone_id = ""
    cidr_block           = ""
    ipv6_cidr_block      = ""
    vpc_id               = ""
    tags                 = tomap({ "" = "" })
  })
  description = <<-EOT
    The subnet object from AWS.
  EOT
}

output "security_group" {
  value = (can(module.security_group[0].security_group) ? {
    id     = module.security_group[0].security_group.id
    arn    = module.security_group[0].security_group.arn
    name   = module.security_group[0].security_group.name
    vpc_id = module.security_group[0].security_group.vpc_id
    tags   = module.security_group[0].security_group.tags
    } : {
    # no object found, but output types are normal
    id     = ""
    arn    = ""
    name   = ""
    vpc_id = ""
    tags   = tomap({ "" = "" })
  })
  description = <<-EOT
    The security group object from AWS.
  EOT
}


output "ssh_key" {
  value = (can(module.ssh_key[0].ssh_key) ? {
    id          = module.ssh_key[0].ssh_key.id
    arn         = module.ssh_key[0].ssh_key.arn
    key_name    = module.ssh_key[0].ssh_key.key_name
    key_pair_id = module.ssh_key[0].ssh_key.key_pair_id
    key_type    = module.ssh_key[0].ssh_key.key_type
    public_key  = module.ssh_key[0].ssh_key.public_key
    tags        = module.ssh_key[0].ssh_key.tags
    } : {
    # no object found, but output types are normal
    id          = ""
    arn         = ""
    key_name    = ""
    key_pair_id = ""
    key_type    = ""
    public_key  = ""
    tags        = tomap({ "" = "" })
  })
  description = <<-EOT
    The SSH key object from AWS.
  EOT
}
