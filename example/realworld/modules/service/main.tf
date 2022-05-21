data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  topic_env_names = { for t in var.sns_topics : "${t.name}_TOPIC_ARN" => module.sns[t.name].arn }
}

module "table" {
  count                    = var.dynamodb_table == null ? 0 : 1
  source                   = "./../../../../modules/terraform-aws-piab-dynamodb-table"
  name                     = var.dynamodb_table.table_name
  hash_key                 = var.dynamodb_table.hash_key
  range_key                = var.dynamodb_table.range_key
  global_secondary_indexes = coalesce(var.dynamodb_table.gsis, [])
  local_secondary_indexes  = coalesce(var.dynamodb_table.lsis, [])
  tags                     = { ServiceName = var.service_name }
  stream_enabled           = var.dynamodb_table.stream_enabled
}

module "sns" {
  for_each   = { for t in var.sns_topics : t.name => t }
  source     = "./../../../../modules/terraform-aws-piab-sns-topic"
  topic_name = each.key
  is_fifo    = each.value.is_fifo
  tags       = { ServiceName = var.service_name }
}

module "queue_access_policies" {
  for_each      = { for h in var.queue_handlers : h.queue_config.name => h.queue_config if h.queue_config.sns_source_name != null }
  source        = "./../../../../modules/terraform-aws-piab-sqs-sns-access-policies"
  sqs_queue_arn = "arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${each.key}"
  sns_topic_arn = module.sns[each.key].topic.arn
}

module "queues" {
  for_each               = { for h in var.queue_handlers : h.queue_config.name => h.queue_config }
  source                 = "./../../../../modules/terraform-aws-piab-sqs-queue"
  queue_name             = each.value.name
  is_fifo                = each.value.is_fifo
  kms_policy_source_json = lookup(module.queue_access_policies, each.key, { kms_policy = null, queue_policy = null }).kms_policy
  queue_policy_json      = lookup(module.queue_access_policies, each.key, { kms_policy = null, queue_policy = null }).queue_policy
  tags                   = { ServiceName = var.service_name }
}

data "archive_file" "source" {
  source_dir  = var.source_folder
  output_path = "./source.zip"
  type        = "zip"
}

data "archive_file" "dependencies" {
  source_dir  = var.dependencies_folder
  output_path = "./dependencies.zip"
  type        = "zip"
}

module "api" {
  count            = var.api_handler == null ? 0 : 1
  source           = "./../../../../modules/terraform-aws-piab-api-gateway"
  api_openapi_spec = templatefile(var.api_handler.api_openapi_spec, { FUNCTION_ARN = module.api_function["apiHandler"].function.invoke_arn })
  api_name         = var.service_name
  alarm_on_500     = true
}

module "api_function" {
  for_each     = { for v in var.api_handler == null ? [] : [var.api_handler] : "apiHandler" => v }
  source       = "./../../../../modules/terraform-aws-piab-lambda"
  name         = "${var.service_name}ApiHandler"
  service_name = var.service_name
  runtime      = "nodejs16.x"
  handler      = var.api_handler.handler
  filename     = data.archive_file.source.output_path
  layers_source = {
    dependencies = data.archive_file.dependencies.output_path
  }
  create_dlq = false
  tags       = { ServiceName = var.service_name, Handles = "API" }
  environment_vars = merge({
    COMMIT_HASH         = var.commit_hash
    DYNAMODB_TABLE_NAME = var.dynamodb_table == null ? "" : var.dynamodb_table.table_name
  }, local.topic_env_names, var.env_vars)
}

module "queue_handlers" {
  for_each     = { for q in var.queue_handlers : q.name => q }
  source       = "./../../../../modules/terraform-aws-piab-lambda"
  name         = "${var.service_name}SQSHandlers${each.value.name}"
  service_name = var.service_name
  runtime      = "nodejs16.x"
  handler      = each.value.handler
  filename     = data.archive_file.source.output_path
  layers_source = {
    dependencies = data.archive_file.dependencies.output_path
  }
  create_dlq = false
  tags       = { ServiceName = var.service_name, Handles = "SQS" }
  environment_vars = merge({
    COMMIT_HASH         = var.commit_hash
    DYNAMODB_TABLE_NAME = var.dynamodb_table == null ? "" : var.dynamodb_table.table_name
  }, local.topic_env_names, var.env_vars)
}

resource "aws_lambda_permission" "lambda_permission" {
  count         = var.api_handler == null ? 0 : 1
  statement_id  = "AllowApiInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.api_function["apiHandler"].function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${module.api[0].api.execution_arn}/*/*/*"
}

data "aws_iam_policy_document" "lambda_permissions" {
  dynamic "statement" {
    for_each = var.dynamodb_table != null ? [1] : []
    content {
      sid = "CanDynamo"

      actions = [
        "dynamodb:GetItem",
        "dynamodb:BatchGetItem",
        "dynamodb:Query",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem",
        "dynamodb:BatchWriteItem"
      ]

      resources = [
        module.table[0].table.arn
      ]
    }
  }
  dynamic "statement" {
    for_each = length(var.sns_topics) > 0 ? [1] : []
    content {
      sid = "CanSns"

      actions = [
        "sns:Publish"
      ]

      resources = module.sns.*.topic.arn
    }
  }
  dynamic "statement" {
    for_each = length(var.queue_handlers) > 0 ? [1] : []
    content {
      sid = "CanSqs"

      actions = [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes"
      ]

      resources = module.queues.*.queue.arn
    }
  }
}

resource "aws_iam_role_policy" "lambda_permission" {
  for_each = { for k, v in merge(module.api_function, module.queue_handlers) : k => v }
  role     = each.value.execution_role.id
  policy   = data.aws_iam_policy_document.lambda_permissions.json
}
