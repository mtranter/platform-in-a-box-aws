locals {
  queue_name = "${var.queue_name}${var.is_fifo ? ".fifo" : ""}"
  dedup      = coalesce(var.content_based_deduplication, var.is_fifo)
}

resource "aws_sqs_queue" "dead_letter_queue" {
  count = var.create_dlq ? 1 : 0
  name  = "${var.queue_name}-dlq${var.is_fifo ? ".fifo" : ""}"

  kms_master_key_id                 = aws_kms_key.key.id
  kms_data_key_reuse_period_seconds = 300

  fifo_queue                  = var.is_fifo
  deduplication_scope         = local.dedup ? var.deduplication_scope : null
  content_based_deduplication = local.dedup

  tags = var.tags
}

resource "aws_sqs_queue" "queue" {
  name                       = local.queue_name
  delay_seconds              = var.delay_seconds
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  redrive_policy             = var.create_dlq ? "{\"deadLetterTargetArn\":\"${aws_sqs_queue.dead_letter_queue[0].arn}\",\"maxReceiveCount\":${var.max_receive_count}}" : null

  kms_master_key_id                 = aws_kms_key.key.id
  kms_data_key_reuse_period_seconds = 300

  fifo_queue                  = var.is_fifo
  deduplication_scope         = var.is_fifo ? var.deduplication_scope : null
  fifo_throughput_limit       = var.is_fifo ? var.fifo_throughput_limit : null
  content_based_deduplication = local.dedup

  tags = var.tags
}

resource "aws_sqs_queue_policy" "this" {
  count     = var.queue_policy_json == null ? 0 : 1
  queue_url = aws_sqs_queue.queue.id
  policy    = var.queue_policy_json
}

module "dlq_alarm" {

  count   = var.alert_on_dlq && var.create_dlq ? 1 : 0
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 2.0"

  alarm_name          = "sqs-dlq-${aws_sqs_queue.queue.name}"
  alarm_description   = "Message from queue ${aws_sqs_queue.queue.name} was forwarded to its dead letter queue"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 1
  period              = 60
  unit                = "Count"

  namespace   = "AWS/SQS"
  metric_name = "NumberOfMessagesReceived"
  statistic   = "Maximum"

  dimensions = {
    QueueName = aws_sqs_queue.queue.name
  }

  alarm_actions = var.alert_topics
}
