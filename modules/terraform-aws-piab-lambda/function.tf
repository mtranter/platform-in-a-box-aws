


locals {
  publish = var.provisioned_concurrency > 0 ? true : var.publish


  insights_layer = var.enable_lambda_insights ? [local.insights_layers_region_map[data.aws_region.current.name]] : []

  tags = merge(
    var.service_name == null ? {} : { "service" : var.service_name },
    var.tags
  )
  env_vars = {
    AWS_NODEJS_CONNECTION_REUSE_ENABLED = "1"
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "${var.name}ExecutionRole"
  assume_role_policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_alias" "lambda_alias" {
  count            = local.publish ? 1 : 0
  name             = "${var.name}Latest"
  function_name    = aws_lambda_function.lambda.arn
  function_version = aws_lambda_function.lambda.version
}

resource "aws_lambda_function" "lambda" {
  function_name                  = var.name
  description                    = var.description
  handler                        = var.handler
  role                           = aws_iam_role.iam_for_lambda.arn
  runtime                        = var.runtime
  filename                       = var.filename
  source_code_hash               = coalesce(var.source_code_hash, filebase64sha256(var.filename))
  timeout                        = var.timeout
  memory_size                    = var.memory_size
  layers                         = concat(var.layers, local.insights_layer, [for l in aws_lambda_layer_version.layers : l.arn])
  publish                        = local.publish
  reserved_concurrent_executions = var.reserved_concurrency

  dynamic "tracing_config" {
    for_each = var.xray_enabled ? [
    1] : []
    content {
      mode = "Active"
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config == null ? [] : [
    var.vpc_config]
    content {
      subnet_ids         = var.vpc_config.subnet_ids
      security_group_ids = var.vpc_config.security_group_ids
    }
  }

  dynamic "file_system_config" {
    for_each = var.file_system_config == null ? [] : [
    1]
    content {
      arn              = var.file_system_config.efs_access_point_arn
      local_mount_path = var.file_system_config.local_mount_path
    }
  }
  dynamic "dead_letter_config" {
    for_each = var.create_dlq ? [
    1] : []
    content {
      target_arn = module.dlq[0].queue.arn
    }
  }

  environment {
    variables = merge(var.environment_vars, local.env_vars)
  }

  tags = local.tags
}

resource "aws_lambda_provisioned_concurrency_config" "provisioned_concurrency" {
  count                             = var.provisioned_concurrency > 0 ? 1 : 0
  function_name                     = aws_lambda_function.lambda.function_name
  provisioned_concurrent_executions = var.provisioned_concurrency
  qualifier                         = aws_lambda_function.lambda.version
}
