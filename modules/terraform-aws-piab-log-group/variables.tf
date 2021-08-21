variable "name" {
  type        = string
  description = "The name of this log group"
}

variable "retention_days" {
  type        = number
  default     = 90
  description = "The number of days the logs will be retained"
}