provider "aws" {
  region = var.region
}

module "vpc_peering_cross_account" {
  source    = "../../"
  namespace = var.namespace
  stage     = var.stage
  name      = var.name

  requester_aws_assume_role_arn             = var.requester_aws_assume_role_arn
  requester_region                          = var.requester_region
  requester_vpc_id                          = var.requester_vpc_id
  requester_allow_remote_vpc_dns_resolution = var.requester_allow_remote_vpc_dns_resolution

  accepter_aws_assume_role_arn             = var.accepter_aws_assume_role_arn
  accepter_region                          = var.accepter_region
  accepter_vpc_id                          = var.accepter_vpc_id
  accepter_allow_remote_vpc_dns_resolution = var.accepter_allow_remote_vpc_dns_resolution
}
