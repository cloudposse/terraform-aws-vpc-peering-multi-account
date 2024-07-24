provider "aws" {
  region = var.region
}

module "requester_vpc" {
  source                  = "cloudposse/vpc/aws"
  version                 = "2.2.0"
  ipv4_primary_cidr_block = "172.16.0.0/16"

  context = module.this.context
}

module "requester_subnets" {
  source               = "cloudposse/dynamic-subnets/aws"
  version              = "2.4.1"
  availability_zones   = var.availability_zones
  vpc_id               = module.requester_vpc.vpc_id
  igw_id               = [module.requester_vpc.igw_id]
  ipv4_cidr_block      = [module.requester_vpc.vpc_cidr_block]
  nat_gateway_enabled  = false
  nat_instance_enabled = false

  context = module.this.context
}

module "accepter_vpc" {
  source                  = "cloudposse/vpc/aws"
  version                 = "2.2.0"
  ipv4_primary_cidr_block = "172.17.0.0/16"

  context = module.this.context
}

module "accepter_subnets" {
  source               = "cloudposse/dynamic-subnets/aws"
  version              = "2.4.1"
  availability_zones   = var.availability_zones
  vpc_id               = module.accepter_vpc.vpc_id
  igw_id               = [module.accepter_vpc.igw_id]
  ipv4_cidr_block      = [module.accepter_vpc.vpc_cidr_block]
  nat_gateway_enabled  = true
  nat_instance_enabled = false

  context = module.this.context
}
