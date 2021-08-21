
data "archive_file" "source" {
  output_path = "./handler"
  type        = "zip"
  source_file = "${path.module}/index.js"
}

#tfsec:ignore:aws-lambda-enable-tracing
module "lambda" {
  source               = "./../..//terraform-aws-piab-lambda"
  create_dlq           = false
  filename             = data.archive_file.source.output_path
  handler              = "index.handler"
  name                 = var.function_name
  publish              = false
  runtime              = "nodejs14.x"
  xray_enabled         = false
  reserved_concurrency = 5
  environment_vars = {
    DELIVERY_STREAM_NAME = var.delivery_stream_name
  }
}

resource "aws_iam_role_policy" "can_sqs" {
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "CanSQS",
            "Effect": "Allow",
            "Action": ["sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"],
            "Resource": "${module.queue.queue.arn}"
        },
        {
            "Sid": "CanFirehose",
            "Effect": "Allow",
            "Action": ["firehose:PutRecordBatch"],
            "Resource": "${var.delivery_stream_arn}"
        }
    ]
}
EOF
  role   = module.lambda.execution_role.id
}


module "sqs_sns_access" {
  source        = "./../..//terraform-aws-piab-sqs-sns-access-policies"
  sns_topic_arn = var.topic_arn
  sqs_queue_arn = module.queue.queue.arn
}

module "queue" {
  source                 = "./../..//terraform-aws-piab-sqs-queue"
  queue_name             = "${var.function_name}Queue"
  is_fifo                = true
  tags                   = {}
  queue_policy_json      = module.sqs_sns_access.queue_policy
  kms_policy_source_json = module.sqs_sns_access.kms_policy
}

module "sqs_subscription" {
  source        = "./../..//terraform-aws-piab-sqs-sns-subscription"
  sns_topic_arn = var.topic_arn
  sqs_queue_arn = module.queue.queue.arn
}

resource "aws_lambda_event_source_mapping" "subscription" {
  event_source_arn = module.queue.queue.arn
  function_name    = module.lambda.function.arn
}
