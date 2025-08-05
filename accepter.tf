# Accepter's credentials
provider "aws" {
  alias                   = "accepter"
  region                  = var.accepter_region
  profile                 = var.accepter_aws_profile
  skip_metadata_api_check = var.skip_metadata_api_check

  dynamic "assume_role" {
    for_each = coalesce(var.accepter_aws_assume_role_arn, "") != "" ? ["true"] : []
    content {
      role_arn = var.accepter_aws_assume_role_arn
    }
  }

  access_key = var.accepter_aws_access_key
  secret_key = var.accepter_aws_secret_key
  token      = var.accepter_aws_token
}

module "accepter" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  enabled = local.accepter_enabled

  attributes = var.add_attribute_tag ? ["accepter"] : []
  tags       = var.add_attribute_tag ? { Side = "accepter" } : {}

  context = module.this.context
}

data "aws_caller_identity" "accepter" {
  count    = local.accepter_count
  provider = aws.accepter
}

data "aws_region" "accepter" {
  count    = local.accepter_count
  provider = aws.accepter
}

# Lookup accepter's VPC so that we can reference the CIDR
data "aws_vpc" "accepter" {
  count    = local.accepter_count
  provider = aws.accepter
  id       = var.accepter_vpc_id
  tags     = var.accepter_vpc_tags
}

# Lookup accepter subnets
data "aws_subnets" "accepter" {
  count    = local.accepter_count
  provider = aws.accepter
  filter {
    name   = "vpc-id"
    values = [local.accepter_vpc_id]
  }
  tags = var.accepter_subnet_tags
}

data "aws_subnet" "accepter" {
  for_each = toset(flatten(data.aws_subnets.accepter[*].ids))
  provider = aws.accepter
  id       = each.value
}

locals {
  accepter_subnet_ids       = local.accepter_enabled ? try(data.aws_subnets.accepter[0].ids, []) : []
  accepter_cidr_blocks      = length(var.accepter_subnet_tags) > 0 ? compact([for s in data.aws_subnet.accepter : s.cidr_block]) : flatten(data.aws_vpc.accepter[*].cidr_block_associations[*].cidr_block)
  accepter_ipv6_cidr_blocks = length(var.accepter_subnet_tags) > 0 ? compact([for s in data.aws_subnet.accepter : s.ipv6_cidr_block]) : compact([for vpc_temp in data.aws_vpc.accepter : vpc_temp.ipv6_cidr_block])
  accepter_vpc_id           = join("", data.aws_vpc.accepter[*].id)
  accepter_account_id       = join("", data.aws_caller_identity.accepter[*].account_id)
  accepter_region           = join("", data.aws_region.accepter[*].name)
}

data "aws_route_tables" "accepter" {
  for_each = toset(local.accepter_subnet_ids)
  provider = aws.accepter
  vpc_id   = local.accepter_vpc_id
  filter {
    name   = "association.subnet-id"
    values = [each.key]
  }
}

# If we had more subnets than routetables, we should update the default.
data "aws_route_tables" "default_rts" {
  count    = local.count
  provider = aws.accepter
  vpc_id   = local.accepter_vpc_id
  filter {
    name   = "association.main"
    values = ["true"]
  }
}

locals {
  accepter_aws_default_rt_id                  = join("", flatten(data.aws_route_tables.default_rts[*].ids))
  accepter_aws_rt_map                         = { for s in local.accepter_subnet_ids : s => try(data.aws_route_tables.accepter[s].ids[0], local.accepter_aws_default_rt_id) }
  accepter_aws_route_table_ids                = distinct(sort(values(local.accepter_aws_rt_map)))
  accepter_aws_route_table_ids_count          = length(local.accepter_aws_route_table_ids)
  accepter_cidr_block_associations            = local.accepter_cidr_blocks
  accepter_cidr_block_associations_count      = length(local.accepter_cidr_block_associations)
  accepter_ipv6_cidr_block_associations       = local.accepter_ipv6_cidr_blocks
  accepter_ipv6_cidr_block_associations_count = length(local.accepter_ipv6_cidr_block_associations)
}

# Create routes from accepter to requester
resource "aws_route" "accepter" {
  count                     = local.enabled ? local.accepter_aws_route_table_ids_count * local.requester_cidr_block_associations_count : 0
  provider                  = aws.accepter
  route_table_id            = local.accepter_aws_route_table_ids[floor(count.index / local.requester_cidr_block_associations_count)]
  destination_cidr_block    = local.requester_cidr_block_associations[count.index % local.requester_cidr_block_associations_count]
  vpc_peering_connection_id = join("", aws_vpc_peering_connection.requester[*].id)
  depends_on = [
    data.aws_route_tables.accepter,
    aws_vpc_peering_connection_accepter.accepter,
    aws_vpc_peering_connection.requester,
  ]

  timeouts {
    create = var.aws_route_create_timeout
    delete = var.aws_route_delete_timeout
  }
}

# Create routes from accepter to requester
resource "aws_route" "accepter_ipv6" {
  count                       = local.enabled ? local.accepter_aws_route_table_ids_count * local.requester_ipv6_cidr_block_associations_count : 0
  provider                    = aws.accepter
  route_table_id              = local.accepter_aws_route_table_ids[floor(count.index / local.requester_ipv6_cidr_block_associations_count)]
  destination_ipv6_cidr_block = local.requester_ipv6_cidr_block_associations[count.index % local.requester_ipv6_cidr_block_associations_count]
  vpc_peering_connection_id   = join("", aws_vpc_peering_connection.requester[*].id)
  depends_on = [
    data.aws_route_tables.accepter,
    aws_vpc_peering_connection_accepter.accepter,
    aws_vpc_peering_connection.requester,
  ]

  timeouts {
    create = var.aws_route_create_timeout
    delete = var.aws_route_delete_timeout
  }
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "accepter" {
  count                     = local.accepter_count
  provider                  = aws.accepter
  vpc_peering_connection_id = join("", aws_vpc_peering_connection.requester[*].id)
  auto_accept               = var.auto_accept
  tags                      = module.accepter.tags
}

resource "aws_vpc_peering_connection_options" "accepter" {
  count                     = local.accepter_count
  provider                  = aws.accepter
  vpc_peering_connection_id = local.active_vpc_peering_connection_id

  accepter {
    allow_remote_vpc_dns_resolution = var.accepter_allow_remote_vpc_dns_resolution
  }
}

output "accepter_connection_id" {
  value       = join("", aws_vpc_peering_connection_accepter.accepter[*].id)
  description = "Accepter VPC peering connection ID"
}

output "accepter_accept_status" {
  value       = join("", aws_vpc_peering_connection_accepter.accepter[*].accept_status)
  description = "Accepter VPC peering connection request status"
}

output "accepter_subnet_route_table_map" {
  value       = local.accepter_aws_rt_map
  description = "Map of accepter VPC subnet IDs to route table IDs"
}
