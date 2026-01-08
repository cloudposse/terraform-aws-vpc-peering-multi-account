variable "requester_aws_profile" {
  description = "Profile used to assume requester_aws_assume_role_arn"
  type        = string
  default     = ""
}

variable "requester_aws_access_key" {
  description = "Access key id to use in requester account"
  type        = string
  default     = null
}

variable "requester_aws_assume_role_arn" {
  description = "Requester AWS Assume Role ARN"
  type        = string
  default     = null
}

variable "requester_aws_secret_key" {
  description = "Secret access key to use in requester account"
  type        = string
  default     = null
}

variable "requester_aws_token" {
  description = "Session token for validating temporary credentials"
  type        = string
  default     = null
}

variable "requester_region" {
  type        = string
  description = "Requester AWS region"
}

variable "requester_subnet_tags" {
  type        = map(string)
  description = "Only add peer routes to requester VPC route tables of subnets matching these tags"
  default     = {}
}

variable "requester_vpc_id" {
  type        = string
  description = "Requester VPC ID filter"
  default     = ""
}

variable "requester_vpc_tags" {
  type        = map(string)
  description = "Requester VPC Tags filter"
  default     = {}
}

variable "requester_allow_remote_vpc_dns_resolution" {
  type        = bool
  default     = true
  description = "Allow requester VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the accepter VPC"
}

# Requestors's credentials
provider "aws" {
  alias                   = "requester"
  region                  = var.requester_region
  profile                 = var.requester_aws_profile
  skip_metadata_api_check = var.skip_metadata_api_check

  dynamic "assume_role" {
    for_each = coalesce(var.requester_aws_assume_role_arn, "") != "" ? ["true"] : []
    content {
      role_arn = var.requester_aws_assume_role_arn
    }
  }

  access_key = var.requester_aws_access_key
  secret_key = var.requester_aws_secret_key
  token      = var.requester_aws_token

}

module "requester" {
  source     = "cloudposse/label/null"
  version    = "0.25.0"
  attributes = var.add_attribute_tag ? ["requester"] : []
  tags       = var.add_attribute_tag ? { Side = "requester" } : {}

  context = module.this.context
}

data "aws_caller_identity" "requester" {
  count    = local.count
  provider = aws.requester
}

data "aws_region" "requester" {
  count    = local.count
  provider = aws.requester
}

# Lookup requester VPC so that we can reference the CIDR
data "aws_vpc" "requester" {
  count    = local.count
  provider = aws.requester
  id       = var.requester_vpc_id
  tags     = var.requester_vpc_tags
}

# Lookup requester subnets
data "aws_subnets" "requester" {
  count    = local.count
  provider = aws.requester
  filter {
    name   = "vpc-id"
    values = [local.requester_vpc_id]
  }
  tags = var.requester_subnet_tags
}

data "aws_subnet" "requester" {
  for_each = toset(flatten(data.aws_subnets.requester[*].ids))
  provider = aws.requester
  id       = each.value
}

locals {
  requester_subnet_ids       = try(distinct(sort(flatten(data.aws_subnets.requester[*].ids))), [])
  requester_cidr_blocks      = length(var.requester_subnet_tags) > 0 ? compact([for s in data.aws_subnet.requester : s.cidr_block]) : flatten(data.aws_vpc.requester[*].cidr_block_associations[*].cidr_block)
  requester_ipv6_cidr_blocks = length(var.requester_subnet_tags) > 0 ? compact([for s in data.aws_subnet.requester : s.ipv6_cidr_block]) : compact([for vpc_temp in data.aws_vpc.requester : vpc_temp.ipv6_cidr_block])
  requester_subnet_ids_count = length(local.requester_subnet_ids)
  requester_vpc_id           = join("", data.aws_vpc.requester[*].id)
}

# Lookup requester route tables
data "aws_route_table" "requester" {
  count     = local.enabled ? local.requester_subnet_ids_count : 0
  provider  = aws.requester
  subnet_id = element(local.requester_subnet_ids, count.index)
}

resource "aws_vpc_peering_connection" "requester" {
  count         = local.count
  provider      = aws.requester
  vpc_id        = local.requester_vpc_id
  peer_vpc_id   = local.accepter_vpc_id
  peer_owner_id = local.accepter_account_id
  peer_region   = local.accepter_region
  auto_accept   = false

  tags = module.requester.tags
}

# Options can't be set until the connection has been accepted and is active,
# so create an explicit dependency on the accepter when setting options.
locals {
  active_vpc_peering_connection_id = local.accepter_enabled ? join("", aws_vpc_peering_connection_accepter.accepter[*].id) : null
}

resource "aws_vpc_peering_connection_options" "requester" {
  # Only provision the options if the accepter side of the peering connection is enabled
  count    = local.accepter_count
  provider = aws.requester

  # As options can't be set until the connection has been accepted
  # create an explicit dependency on the accepter.
  vpc_peering_connection_id = local.active_vpc_peering_connection_id

  requester {
    allow_remote_vpc_dns_resolution = var.requester_allow_remote_vpc_dns_resolution
  }
}

locals {
  requester_aws_route_table_ids                = try(distinct(sort(data.aws_route_table.requester[*].route_table_id)), [])
  requester_aws_route_table_ids_count          = length(local.requester_aws_route_table_ids)
  requester_cidr_block_associations            = local.requester_cidr_blocks
  requester_cidr_block_associations_count      = length(local.requester_cidr_block_associations)
  requester_ipv6_cidr_block_associations       = local.requester_ipv6_cidr_blocks
  requester_ipv6_cidr_block_associations_count = length(local.requester_ipv6_cidr_block_associations)
}

# Create routes from requester to accepter
resource "aws_route" "requester" {
  count                     = local.enabled ? local.requester_aws_route_table_ids_count * local.accepter_cidr_block_associations_count : 0
  provider                  = aws.requester
  route_table_id            = local.requester_aws_route_table_ids[floor(count.index / local.accepter_cidr_block_associations_count)]
  destination_cidr_block    = local.accepter_cidr_block_associations[count.index % local.accepter_cidr_block_associations_count]
  vpc_peering_connection_id = join("", aws_vpc_peering_connection.requester[*].id)
  depends_on = [
    data.aws_route_table.requester,
    aws_vpc_peering_connection.requester,
    aws_vpc_peering_connection_accepter.accepter
  ]

  timeouts {
    create = var.aws_route_create_timeout
    delete = var.aws_route_delete_timeout
  }
}

# Create routes from requester to accepter
resource "aws_route" "requester_ipv6" {
  count                       = local.enabled ? local.requester_aws_route_table_ids_count * local.accepter_ipv6_cidr_block_associations_count : 0
  provider                    = aws.requester
  route_table_id              = local.requester_aws_route_table_ids[floor(count.index / local.accepter_ipv6_cidr_block_associations_count)]
  destination_ipv6_cidr_block = local.accepter_ipv6_cidr_block_associations[count.index % local.accepter_ipv6_cidr_block_associations_count]
  vpc_peering_connection_id   = join("", aws_vpc_peering_connection.requester[*].id)
  depends_on = [
    data.aws_route_table.requester,
    aws_vpc_peering_connection.requester,
    aws_vpc_peering_connection_accepter.accepter
  ]

  timeouts {
    create = var.aws_route_create_timeout
    delete = var.aws_route_delete_timeout
  }
}

output "requester_connection_id" {
  value       = join("", aws_vpc_peering_connection.requester[*].id)
  description = "Requester VPC peering connection ID"
}

output "requester_accept_status" {
  value       = join("", aws_vpc_peering_connection.requester[*].accept_status)
  description = "Requester VPC peering connection request status"
}
