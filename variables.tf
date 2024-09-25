variable "auto_accept" {
  type        = bool
  default     = true
  description = "Automatically accept the peering"
}

variable "accepter_enabled" {
  description = "Flag to enable/disable the accepter side of the peering connection"
  type        = bool
  default     = true
}

variable "accepter_aws_access_key" {
  description = "Access key id to use in accepter account"
  type        = string
  default     = null
}

variable "accepter_aws_profile" {
  description = "Profile used to assume accepter_aws_assume_role_arn"
  type        = string
  default     = ""
}

variable "accepter_aws_assume_role_arn" {
  description = "Accepter AWS Assume Role ARN"
  type        = string
  default     = null
}

variable "accepter_aws_secret_key" {
  description = "Secret access key to use in accepter account"
  type        = string
  default     = null
}

variable "accepter_aws_token" {
  description = "Session token for validating temporary credentials"
  type        = string
  default     = null
}

variable "accepter_region" {
  type        = string
  description = "Accepter AWS region"
}

variable "accepter_vpc_id" {
  type        = string
  description = "Accepter VPC ID filter"
  default     = ""
}

variable "accepter_vpc_tags" {
  type        = map(string)
  description = "Accepter VPC Tags filter"
  default     = {}
}

variable "accepter_subnet_tags" {
  type        = map(string)
  description = "Only add peer routes to accepter VPC route tables of subnets matching these tags"
  default     = {}
}

variable "accepter_allow_remote_vpc_dns_resolution" {
  type        = bool
  default     = true
  description = "Allow accepter VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the requester VPC"
}

variable "skip_metadata_api_check" {
  type        = bool
  default     = false
  description = "Don't use the credentials of EC2 instance profile"
}

variable "add_attribute_tag" {
  type        = bool
  default     = true
  description = "If `true` will add additional attribute tag to the requester and accceptor resources"
}

variable "aws_route_create_timeout" {
  type        = string
  default     = "5m"
  description = "Time to wait for AWS route creation specifed as a Go Duration, e.g. `2m`"
}

variable "aws_route_delete_timeout" {
  type        = string
  default     = "5m"
  description = "Time to wait for AWS route deletion specifed as a Go Duration, e.g. `5m`"
}
