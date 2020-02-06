variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating or accessing any resources"
}

variable "namespace" {
  description = "Namespace (e.g. `eg` or `cp`)"
  type        = string
}

variable "stage" {
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  type        = string
}

variable "name" {
  description = "Name  (e.g. `app` or `cluster`)"
  type        = string
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name`, and `attributes`"
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `a` or `b`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `{\"BusinessUnit\" = \"XYZ\"`)"
}

variable "auto_accept" {
  type        = bool
  default     = true
  description = "Automatically accept the peering"
}

