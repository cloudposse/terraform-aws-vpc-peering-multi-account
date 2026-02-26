provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "requester"
  region = var.requester_region

  assume_role {
    role_arn = var.requester_aws_assume_role_arn
  }
}

provider "aws" {
  alias  = "accepter"
  region = var.accepter_region

  dynamic "assume_role" {
    for_each = var.accepter_aws_assume_role_arn != null ? [var.accepter_aws_assume_role_arn] : []
    content {
      role_arn = assume_role.value
    }
  }
}

module "vpc_peering_cross_account" {
  source = "../../"

  providers = {
    aws.requester = aws.requester
    aws.accepter  = aws.accepter
  }

  requester_vpc_id                          = var.requester_vpc_id
  requester_allow_remote_vpc_dns_resolution = var.requester_allow_remote_vpc_dns_resolution

  accepter_enabled                         = var.accepter_enabled
  accepter_vpc_id                          = var.accepter_vpc_id
  accepter_allow_remote_vpc_dns_resolution = var.accepter_allow_remote_vpc_dns_resolution

  context = module.this.context
}
