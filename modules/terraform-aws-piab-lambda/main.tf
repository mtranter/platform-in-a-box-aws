terraform {
  experiments = [module_variable_optional_attrs]
}

locals {
  lambda_insights_extension_layer = "arn:aws:lambda:${data.aws_region.current.name}:580247275435:layer:LambdaInsightsExtension:14"
}

data "aws_region" "current" {}

module "log_group" {
  source = "./..//terraform-aws-piab-log-group"
  name   = "/aws/lambda/${var.name}"
}

data "aws_iam_policy_document" "can_log" {

  #tfsec:ignore:aws-iam-no-policy-wildcards Lambda needs permission to create log streams
  statement {
    sid = "CanLog"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      module.log_group.log_group.arn,
      "${module.log_group.log_group.arn}:*"
    ]
  }
}

data "aws_iam_policy_document" "allow_dlq_kms_access" {
  statement {
    sid = "AllowLambdaDlqAccess"
    actions = [
      "kms:Encrypt",
      "kms:ReEncrypt",
      "kms:Decrypt",
      "kms:GenerateDataKey*",
    "kms:DescribeKey"]
    principals {
      identifiers = [aws_iam_role.iam_for_lambda.arn]
      type        = "AWS"
    }
    effect = "Allow"
    resources = [
    "*"]
  }
}

module "dlq" {
  count                  = var.create_dlq == true ? 1 : 0
  source                 = "./..//terraform-aws-piab-sqs-queue"
  create_dlq             = false
  queue_name             = "${replace(var.name, ".", "_")}_dlq"
  tags                   = var.tags
  is_fifo                = false
  kms_policy_source_json = data.aws_iam_policy_document.allow_dlq_kms_access.json
}

data "aws_iam_policy_document" "can_sqs_dlq" {
  count = var.create_dlq == true ? 1 : 0
  statement {
    sid = "CanSQSDLQ"
    actions = [
      "sqs:SendMessage"
    ]
    resources = [
    module.dlq[count.index].queue.arn]
  }
}

resource "aws_lambda_layer_version" "layers" {
  for_each         = var.layers_source
  layer_name       = each.key
  source_code_hash = filebase64sha256(each.value)
  filename         = each.value
  compatible_runtimes = [
  var.runtime]
}

resource "aws_iam_role_policy" "dlq_role" {
  count  = var.create_dlq == true ? 1 : 0
  name   = "${var.name}DLQ"
  role   = aws_iam_role.iam_for_lambda.id
  policy = data.aws_iam_policy_document.can_sqs_dlq[0].json
}

resource "aws_iam_role_policy_attachment" "iam_for_lambda_role_eni" {
  count      = var.vpc_config == null ? 0 : 1
  role       = aws_iam_role.iam_for_lambda.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "aws_xray_write_only_access" {
  count      = var.xray_enabled == null ? 0 : 1
  role       = aws_iam_role.iam_for_lambda.id
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}

resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy"
  role       = aws_iam_role.iam_for_lambda.id
}

resource "aws_iam_role_policy" "can_log" {
  policy = data.aws_iam_policy_document.can_log.json
  role   = aws_iam_role.iam_for_lambda.id
}

resource "aws_iam_role_policy_attachment" "insights_policy" {
  count      = var.enable_lambda_insights ? 1 : 0
  role       = aws_iam_role.iam_for_lambda.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy"
}
