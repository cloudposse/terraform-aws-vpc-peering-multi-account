variable "requester_aws_assume_role_arn" {
  description = "Requester AWS Assume Role ARN"
  type        = string
}

variable "requester_region" {
  type        = string
  description = "Requester AWS region"
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
  alias  = "requester"
  region = var.requester_region

  dynamic "assume_role" {
    for_each = var.requester_aws_assume_role_arn != "" ? ["true"] : []
    content {
      role_arn = var.requester_aws_assume_role_arn
    }
  }

}

locals {
  requester_attributes = concat(var.attributes, ["requester"])
  requester_tags = merge(
    var.tags,
    {
      "Side" = "requester"
    },
  )
}

module "requester" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  enabled    = var.enabled
  namespace  = var.namespace
  name       = var.name
  stage      = var.stage
  delimiter  = var.delimiter
  attributes = local.requester_attributes
  tags       = local.requester_tags
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
data "aws_subnet_ids" "requester" {
  count    = local.count
  provider = aws.requester
  vpc_id   = local.requester_vpc_id
}

locals {
  requester_subnet_ids       = distinct(sort(flatten(data.aws_subnet_ids.requester.*.ids)))
  requester_subnet_ids_count = length(local.requester_subnet_ids)
  requester_vpc_id           = join("", data.aws_vpc.requester.*.id)
}

# Lookup requester route tables
data "aws_route_table" "requester" {
  count     = var.enabled ? local.requester_subnet_ids_count : 0
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
  active_vpc_peering_connection_id = join("", aws_vpc_peering_connection_accepter.accepter.*.id)
}

resource "aws_vpc_peering_connection_options" "requester" {
  provider = aws.requester

  # As options can't be set until the connection has been accepted
  # create an explicit dependency on the accepter.
  vpc_peering_connection_id = local.active_vpc_peering_connection_id

  requester {
    allow_remote_vpc_dns_resolution = var.requester_allow_remote_vpc_dns_resolution
  }
}

locals {
  requester_aws_route_table_ids           = distinct(sort(data.aws_route_table.requester.*.route_table_id))
  requester_aws_route_table_ids_count     = length(local.requester_aws_route_table_ids)
  requester_cidr_block_associations       = flatten(data.aws_vpc.requester.*.cidr_block_associations)
  requester_cidr_block_associations_count = length(local.requester_cidr_block_associations)
}

# Create routes from requester to accepter
resource "aws_route" "requester" {
  count                     = var.enabled ? local.requester_aws_route_table_ids_count * local.accepter_cidr_block_associations_count : 0
  provider                  = aws.requester
  route_table_id            = local.requester_aws_route_table_ids[ceil(count.index / local.accepter_cidr_block_associations_count)]
  destination_cidr_block    = local.accepter_cidr_block_associations[count.index % local.accepter_cidr_block_associations_count]["cidr_block"]
  vpc_peering_connection_id = join("", aws_vpc_peering_connection.requester.*.id)
  depends_on = [
    data.aws_route_table.requester,
    aws_vpc_peering_connection.requester,
    aws_vpc_peering_connection_accepter.accepter,
  ]
}

output "requester_connection_id" {
  value       = join("", aws_vpc_peering_connection.requester.*.id)
  description = "Requester VPC peering connection ID"
}

output "requester_accept_status" {
  value       = join("", aws_vpc_peering_connection.requester.*.accept_status)
  description = "Requester VPC peering connection request status"
}

