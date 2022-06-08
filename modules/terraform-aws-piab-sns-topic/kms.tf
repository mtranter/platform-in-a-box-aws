resource "aws_kms_alias" "alias" {
  target_key_id = aws_kms_key.key.id
  name          = "alias/sns/${replace(local.topic_name, ".", "-")}"
}

data "aws_caller_identity" "me" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "key_policy" {
  policy_id               = "SNS${local.topic_name}KeyPolicy"
  source_policy_documents = var.key_policy_sources

  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      identifiers = [
      "arn:aws:iam::${data.aws_caller_identity.me.account_id}:root"]
      type = "AWS"
    }
    actions = [
    "kms:*"]
    resources = [
    "*"]
  }
  statement {
    sid    = "Allow access through Amazon SNS for all principals in the account that are authorized to use Amazon SNS"
    effect = "Allow"
    principals {
      identifiers = ["*"]
      type = "AWS"
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:CreateGrant",
    "kms:DescribeKey"]
    resources = [
    "*"]
    condition {
      test = "StringEquals"
      values = [
      "sns.${data.aws_region.current.name}.amazonaws.com"]
      variable = "kms:ViaService"
    }
    condition {
      test = "StringEquals"
      values = [
      data.aws_caller_identity.me.account_id]
      variable = "kms:CallerAccount"
    }
  }
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
    resources = [
    "*"]
  }
}

resource "aws_kms_key" "key" {
  # checkov:skip=CKV_AWS_33: Using CallerAccount predicate
  description         = "Key for sns topic ${local.topic_name}"
  enable_key_rotation = true
  policy              = data.aws_iam_policy_document.key_policy.json
}
