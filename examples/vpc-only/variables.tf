variable "region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zone IDs"
}
