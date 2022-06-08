variable "topic_name" {
  type = string
}

variable "task_name" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "bucket_prefix" {
  type = string
}