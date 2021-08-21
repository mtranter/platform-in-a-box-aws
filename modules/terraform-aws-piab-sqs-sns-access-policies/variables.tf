variable "sns_topic_arn" {
  type        = string
  description = "The ARN of the SNS topic that that SQS queue will subscribe to"
}

variable "sqs_queue_arn" {
  type        = string
  description = "The queue arn"
}
