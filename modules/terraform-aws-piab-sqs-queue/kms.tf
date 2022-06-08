resource "aws_kms_alias" "alias" {
  target_key_id = aws_kms_key.key.id
  name          = "alias/sqs/${replace(local.queue_name, ".", "-")}"
}

data "aws_caller_identity" "me" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "key_policy" {
  source_policy_documents = [var.kms_policy_source_json]
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      identifiers = [
      "arn:aws:iam::${data.aws_caller_identity.me.account_id}:root"]
      type = "AWS"
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
  statement {
    sid    = "Allow access through Amazon SQS for all principals in the account that are authorized to use Amazon SQS"
    effect = "Allow"
    principals {
      identifiers = [
      "arn:aws:iam::${data.aws_caller_identity.me.account_id}:*"]
      type = "AWS"
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:CreateGrant",
    "kms:DescribeKey"]
    resources = ["*"]
    condition {
      test = "StringEquals"
      values = [
      "sqs.${data.aws_region.current.name}.amazonaws.com"]
      variable = "kms:ViaService"
    }
    condition {
      test = "StringEquals"
      values = [
      data.aws_caller_identity.me.account_id]
      variable = "kms:CallerAccount"
    }
  }
}

resource "aws_kms_key" "key" {
  # checkov:skip=CKV_AWS_33: Using CallerAccount predicate
  description         = "Key for sns topic ${local.queue_name}"
  enable_key_rotation = true
  policy              = data.aws_iam_policy_document.key_policy.json
}
