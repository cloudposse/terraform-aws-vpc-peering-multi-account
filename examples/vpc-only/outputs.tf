output "accepter_vpc_id" {
  value       = module.accepter_vpc.vpc_id
  description = "Accepter VPC id"
}

output "requester_vpc_id" {
  value       = module.requester_vpc.vpc_id
  description = "Requester VPC id"
}
