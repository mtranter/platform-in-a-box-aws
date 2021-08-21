variable "topic_name" {
  type = string
}

variable "task_name" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "is_fifo" {
  type = bool
}

variable "content_based_deduplication" {
  type    = bool
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "bucket_kms_key_arn" {
  type    = string
  default = null
}

variable "bucket_prefix" {
  type = string
}