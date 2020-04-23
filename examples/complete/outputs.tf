output "requester_connection_id" {
  value       = module.vpc_peering_cross_account.requester_connection_id
  description = "Requester VPC peering connection ID"
}

output "requester_accept_status" {
  value       = module.vpc_peering_cross_account.requester_accept_status
  description = "Requester VPC peering connection request status"
}

output "accepter_connection_id" {
  value       = module.vpc_peering_cross_account.accepter_connection_id
  description = "Accepter VPC peering connection ID"
}

output "accepter_accept_status" {
  value       = module.vpc_peering_cross_account.accepter_accept_status
  description = "Accepter VPC peering connection request status"
}
