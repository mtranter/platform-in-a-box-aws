

data "aws_iam_policy_document" "queue_policy" {
  statement {
    sid    = "SNSCanSendToQueue"
    effect = "Allow"
    principals {
      identifiers = [
      "sns.amazonaws.com"]
      type = "Service"
    }
    actions = [
      "sqs:SendMessage"
    ]
    resources = [var.sqs_queue_arn]
    condition {
      test     = "ArnEquals"
      values   = [var.sns_topic_arn]
      variable = "aws:SourceArn"
    }
  }
}

data "aws_iam_policy_document" "allow_sns_kms_queue_access" {
  statement {
    sid    = "AllowSNS"
    effect = "Allow"
    principals {
      identifiers = [
      "sns.amazonaws.com"]
      type = "Service"
    }
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey*"
    ]
    resources = ["*"]
    condition {
      test     = "ArnEquals"
      values   = [var.sns_topic_arn]
      variable = "aws:SourceArn"
    }
  }
}
