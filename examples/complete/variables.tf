variable "region" {
  type        = string
  description = "AWS Region"
}

variable "requester_aws_assume_role_arn" {
  type        = string
  description = "Requester AWS Assume Role ARN"
}

variable "requester_region" {
  type        = string
  description = "Requester AWS region"
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

variable "accepter_enabled" {
  description = "Flag to enable/disable the accepter side of the peering connection"
  type        = bool
  default     = true
}

variable "accepter_aws_assume_role_arn" {
  type        = string
  description = "Accepter AWS Assume Role ARN"
  default     = null
}

variable "accepter_region" {
  type        = string
  description = "Accepter AWS region"
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
