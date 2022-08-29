variable "queue_name" {
  type        = string
  description = "Queue name. '.fifo' will be appended to the name if is_fifo = true"
}

variable "create_dlq" {
  type        = bool
  default     = true
  description = "If true, will create a DLQ for this queue"
}

variable "max_receive_count" {
  description = "Maximum retries before moving a message to dlq. Default 100"
  type        = number
  default     = 100
}

variable "tags" {
  type    = map(string)
  default = null
}

variable "delay_seconds" {
  description = "The queue delay seconds. Default 0"
  default     = 0
  type        = number
}

variable "message_retention_seconds" {
  type        = number
  default     = 1209600
  description = "The number of seconds for which a message will be retained"
}

variable "visibility_timeout_seconds" {
  default     = 30
  type        = number
  description = "The visibility timeout in seconds"
}

variable "is_fifo" {
  type        = bool
  description = "Creates a FIFO queue if set"
}

variable "content_based_deduplication" {
  type    = bool
  default = null
}

variable "deduplication_scope" {
  type    = string
  default = "messageGroup"
  validation {
    condition     = var.deduplication_scope == null || var.deduplication_scope == "messageGroup" || var.deduplication_scope == "queue"
    error_message = "The deduplication_scope value must be either messageGroup or queue."
  }
  description = "The deduplication scope. Either `messageGroup` or `queue`"
}

variable "fifo_throughput_limit" {
  type    = string
  default = "perMessageGroupId"
  validation {
    condition     = var.fifo_throughput_limit == null || var.fifo_throughput_limit == "perMessageGroupId" || var.fifo_throughput_limit == "perQueue"
    error_message = "The deduplication_scope value must be either perMessageGroupId or perQueue."
  }
  description = "The fifo throughput limit. Either `perMessageGroupId` or `perQueue`"
}

variable "kms_policy_source_json" {
  default     = null
  type        = string
  description = "An additional policy to add to the KMS Key that will be used to encrypt this data"
}

variable "queue_policy_json" {
  default     = null
  type        = string
  description = "The queue access policy json."
}

variable "alert_on_dlq" {
  default     = true
  type        = bool
  description = "Create a cloudwatch alert if messages are sent to the Dead Letter Queue"
}

variable "alert_topics" {
  type        = list(string)
  description = "(optional) List of SNS topic arns that will be used to broadcast Cloudwatch Alarms"
  default     = null
}