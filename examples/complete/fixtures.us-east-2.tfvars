region = "us-east-2"

namespace = "eg"

stage = "test"

name = "vpc_peering_cross_account"

requester_aws_assume_role_arn = ""

requester_region = "us-east-2"

requester_allow_remote_vpc_dns_resolution = true

accepter_aws_assume_role_arn = ""

accepter_region = "us-east-2"

accepter_exclude_cidrs = ["100.64.0.0/16"]

accepter_allow_remote_vpc_dns_resolution = true

availability_zones = ["us-east-2b"]
