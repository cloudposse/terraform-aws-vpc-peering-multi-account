# Accepter's credentials
provider "aws" {
  alias                   = "accepter"
  region                  = var.accepter_region
  profile                 = var.accepter_aws_profile
  skip_metadata_api_check = var.skip_metadata_api_check

  dynamic "assume_role" {
    for_each = local.enabled && var.accepter_aws_assume_role_arn != "" ? ["true"] : []
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
  dynamic "filter" {
    for_each = var.accepter_subnet_tags
    content {
      name   = "tag:${filter.key}"
      values = [filter.value]
    }
  }
}

locals {
  accepter_subnet_ids       = try(local.accepter_enabled ? data.aws_subnets.accepter[0].ids : [], [])
  accepter_subnet_ids_count = length(local.accepter_subnet_ids)
  accepter_vpc_id           = join("", data.aws_vpc.accepter.*.id)
  accepter_account_id       = join("", data.aws_caller_identity.accepter.*.account_id)
  accepter_region           = join("", data.aws_region.accepter.*.name)
}

# Lookup accepter route tables
data "aws_route_tables" "accepter" {
  count    = local.count
  provider = aws.accepter
  vpc_id   = local.accepter_vpc_id
  filter {
    name   = "association.subnet-id"
    values = local.accepter_subnet_ids
  }
}
locals {
  aws_subnets_count      = length(data.aws_subnets.accepter.*.ids)
  aws_route_tables_count = length(data.aws_route_tables.accepter.*.id)
}

# If we had more subnets than routetables, we should update the default.
data "aws_route_tables" "default_rts" {
  count    = local.enabled && local.aws_subnets_count > local.aws_route_tables_count ? 1 : 0
  provider = aws.accepter
  vpc_id   = local.accepter_vpc_id
  filter {
    name   = "association.main"
    values = ["true"]
  }
}

locals {
  accepter_aws_route_table_ids           = try(distinct(sort(concat(data.aws_route_tables.accepter[0].ids, data.aws_route_tables.default_rts[0].ids))), [])
  accepter_aws_route_table_ids_count     = length(local.accepter_aws_route_table_ids)
  accepter_cidr_block_associations       = flatten(data.aws_vpc.accepter.*.cidr_block_associations)
  accepter_cidr_block_associations_count = length(local.accepter_cidr_block_associations)
}

# Create routes from accepter to requester
resource "aws_route" "accepter" {
  count                     = local.enabled ? local.accepter_aws_route_table_ids_count * local.requester_cidr_block_associations_count : 0
  provider                  = aws.accepter
  route_table_id            = local.accepter_aws_route_table_ids[floor(count.index / local.requester_cidr_block_associations_count)]
  destination_cidr_block    = local.requester_cidr_block_associations[count.index % local.requester_cidr_block_associations_count]["cidr_block"]
  vpc_peering_connection_id = join("", aws_vpc_peering_connection.requester.*.id)
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
  vpc_peering_connection_id = join("", aws_vpc_peering_connection.requester.*.id)
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
  value       = join("", aws_vpc_peering_connection_accepter.accepter.*.id)
  description = "Accepter VPC peering connection ID"
}

output "accepter_accept_status" {
  value       = join("", aws_vpc_peering_connection_accepter.accepter.*.accept_status)
  description = "Accepter VPC peering connection request status"
}
