variable "service_name" {
  type = string
}
variable "commit_hash" {
  type = string
}

variable "topic_arns" {
  type = list(string)
}

variable "table_name" {
  type = string
}

data "archive_file" "source" {
  source_file = "${path.module}/index.js"
  output_path = "./source.zip"
  type        = "zip"
}

module "streams_handler" {
  source       = "./../../../../modules/terraform-aws-piab-lambda"
  name         = "${var.service_name}DynamoEventDispatcher"
  service_name = var.service_name
  runtime      = "nodejs16.x"
  handler      = "index.handler"
  filename     = data.archive_file.source.output_path

  create_dlq = true
  tags       = { ServiceName = var.service_name, Handles = "DynamoDBStreams" }
  environment_vars = {
    COMMIT_HASH = var.commit_hash
  }
}

resource "aws_iam_role_policy" "events_handler_can_dynamo" {
  name   = "${var.service_name}DynamoEventDispatcher"
  role   = module.streams_handler.execution_role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowLambdaFunctionInvocation",
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "APIAccessForDynamoDBStreams",
            "Effect": "Allow",
            "Action": [
                "dynamodb:GetRecords",
                "dynamodb:GetShardIterator",
                "dynamodb:DescribeStream",
                "dynamodb:ListStreams"
            ],
            "Resource": "${data.aws_dynamodb_table.table.arn}/stream/*"
        },
        {
            "Sid": "SNSAccess",
            "Effect": "Allow",
            "Action": [
                "sns:Publish"
            ],
            "Resource": ${jsonencode(var.topic_arns)}
        }
    ]
}
EOF
}

data "aws_dynamodb_table" "table" {
  name = var.table_name
}

resource "aws_lambda_event_source_mapping" "streams_source" {
  event_source_arn  = data.aws_dynamodb_table.table.stream_arn
  function_name     = module.streams_handler.function.arn
  starting_position = "LATEST"
  filter_criteria {
    filter {
      pattern = jsonencode({
        eventName = ["INSERT"]
        dynamodb = {
          NewImage = {
            isEvent = {
              BOOL = [true]
            }
          }
        }
      })
    }
  }

}
