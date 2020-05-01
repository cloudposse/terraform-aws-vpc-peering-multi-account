variable "region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "namespace" {
  type        = string
  description = "Namespace (e.g. `eg` or `cp`)"
  default     = "eg"
}

variable "stage" {
  type        = string
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  default     = "testing"
}

variable "name" {
  type        = string
  description = "Name of the application"
  default     = "vpc-peering"
}

variable "requester_aws_assume_role_arn" {
  type        = string
  description = "Requester AWS Assume Role ARN"
}

variable "requester_region" {
  type        = string
  description = "Requester AWS region"
  default     = "us-west-2"
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

variable "accepter_aws_assume_role_arn" {
  type        = string
  description = "Accepter AWS Assume Role ARN"
}

variable "accepter_region" {
  type        = string
  description = "Accepter AWS region"
  default     = "us-east-1"
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
