variable "requester_region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "accepter_region" {
  type        = string
  description = "AWS Region"
  default     = "us-west-2"
}

variable "requester_availability_zones" {
  type        = list(string)
  description = "Availability zone IDs in Requester region."
}

variable "accepter_availability_zones" {
  type        = list(string)
  description = "Availability zone IDs in Accepter region."
}
