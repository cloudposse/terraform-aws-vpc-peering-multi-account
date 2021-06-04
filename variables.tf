variable "auto_accept" {
  type        = bool
  default     = true
  description = "Automatically accept the peering"
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
