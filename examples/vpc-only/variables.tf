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

variable "availability_zones" {
  type        = list(string)
  description = "Availability zone IDs"
}
