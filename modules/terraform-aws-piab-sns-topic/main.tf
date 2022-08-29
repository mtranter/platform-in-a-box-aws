locals {
  topic_name = "${replace(var.topic_name, ".", "_")}${var.is_fifo ? ".fifo" : ""}"
  dedup      = coalesce(var.content_based_deduplication, var.is_fifo)
}


resource "aws_iam_role" "failures_log" {
  name = "${local.topic_name}CanLog"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "sns.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy_document" "can_log" {
  version = "2012-10-17"
  #tfsec:ignore:aws-iam-no-policy-wildcards SNS needs permission to create log streams/groups
  statement {
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_role_policy" "can_log" {
  policy = data.aws_iam_policy_document.can_log.json
  role   = aws_iam_role.failures_log.id
}

data "aws_iam_policy_document" "topic_policy" {
  count                   = length(coalesce(var.topic_policy_sources, [])) > 0 ? 1 : 0
  source_policy_documents = var.topic_policy_sources

}

resource "aws_sns_topic" "topic" {
  name                                  = local.topic_name
  fifo_topic                            = var.is_fifo
  content_based_deduplication           = local.dedup
  kms_master_key_id                     = aws_kms_key.key.id
  tags                                  = var.tags
  application_failure_feedback_role_arn = aws_iam_role.failures_log.arn
  http_failure_feedback_role_arn        = aws_iam_role.failures_log.arn
  lambda_failure_feedback_role_arn      = aws_iam_role.failures_log.arn
  sqs_failure_feedback_role_arn         = aws_iam_role.failures_log.arn
  policy                                = length(coalesce(var.topic_policy_sources, [])) > 0 ? data.aws_iam_policy_document.topic_policy[0].json : null
}

module "errors_alarm" {

  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 2.0"

  alarm_name          = "sns-topic-${aws_sns_topic.topic.name}-delivery-failed"
  alarm_description   = "SNS Topic ${aws_sns_topic.topic.name} delivery has failed"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 1
  period              = 60
  unit                = "Count"

  namespace   = "AWS/SNS"
  metric_name = "NumberOfNotificationsFailed"
  statistic   = "Maximum"

  dimensions = {
    TopicName = aws_sns_topic.topic.name
  }

  alarm_actions = var.alert_topics
}
