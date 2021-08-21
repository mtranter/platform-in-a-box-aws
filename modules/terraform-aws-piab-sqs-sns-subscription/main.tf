locals {
  is_fifo    = reverse(split(".", var.sns_topic_arn))[0] == "fifo"
  queue_name = split(".", data.aws_arn.queue.resource)[0]
  topic_name = split(".", data.aws_arn.topic.resource)[0]
}

data "aws_arn" "topic" {
  arn = var.sns_topic_arn
}

data "aws_arn" "queue" {
  arn = var.sqs_queue_arn
}

resource "aws_sns_topic_subscription" "subscription" {
  endpoint             = var.sqs_queue_arn
  protocol             = "sqs"
  topic_arn            = var.sns_topic_arn
  raw_message_delivery = var.raw_message_delivery
  redrive_policy       = "{\"deadLetterTargetArn\": \"${module.dlq.queue.arn}\"}"
}

module "sqs_sns_access" {
  source        = "./..//terraform-aws-piab-sqs-sns-access-policies"
  sns_topic_arn = var.sns_topic_arn
  sqs_queue_arn = var.sqs_queue_arn
}

module "dlq" {
  source                 = "./..//terraform-aws-piab-sqs-queue"
  queue_name             = "${substr(local.topic_name, 0, 36)}-${substr(local.topic_name, 0, 36)}-dlq${local.is_fifo ? ".fifo" : ""}"
  is_fifo                = local.is_fifo
  create_dlq             = false
  max_receive_count      = 1000
  kms_policy_source_json = module.sqs_sns_access.queue_policy
  queue_policy_json      = module.sqs_sns_access.kms_policy
}
