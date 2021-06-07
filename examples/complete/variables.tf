variable "region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "requester_vpc_id" {
  type        = string
  description = "Requester VPC ID filter"
}

variable "requester_allow_remote_vpc_dns_resolution" {
  type        = bool
  description = "Allow requester VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the accepter VPC"
  default     = true
}

variable "accepter_vpc_id" {
  type        = string
  description = "Accepter VPC ID filter"
}

variable "accepter_allow_remote_vpc_dns_resolution" {
  type        = bool
  description = "Allow accepter VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the requester VPC"
  default     = true
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zone IDs"
}
