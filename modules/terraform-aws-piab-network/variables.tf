variable "vpc_cidr" {
  type        = string
  description = "The CIDR for the VPC"
}

variable "vpc_name" {
  type        = string
  description = "The name of the VPC"
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Tags for the resources created"
}
