data "aws_sns_topic" "topic" {
  name = var.topic_name
}

data "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

resource "aws_iam_role" "sns_can_firehose" {
  name               = "SNS${var.topic_name}CanFirehose"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "sns.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "can_firehose" {
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "firehose:DescribeDeliveryStream",
        "firehose:ListDeliveryStreams",
        "firehose:ListTagsForDeliveryStream",
        "firehose:PutRecord",
        "firehose:PutRecordBatch"
      ],
      "Resource": [
        "${aws_kinesis_firehose_delivery_stream.stream.arn}"
      ],
      "Effect": "Allow"
    }
  ]
}
EOF
  role   = aws_iam_role.sns_can_firehose.id
}

module "forwarder" {
  count                = var.is_fifo ? 1 : 0
  source               = "./fifo_forwarder"
  topic_arn            = data.aws_sns_topic.topic.arn
  delivery_stream_name = aws_kinesis_firehose_delivery_stream.stream.name
  function_name        = "${var.task_name}FirehoseForwarder"
  delivery_stream_arn  = aws_kinesis_firehose_delivery_stream.stream.arn
}

resource "aws_sns_topic_subscription" "subscription" {
  count                 = var.is_fifo ? 0 : 1
  endpoint              = aws_kinesis_firehose_delivery_stream.stream.arn
  protocol              = "firehose"
  topic_arn             = data.aws_sns_topic.topic.arn
  subscription_role_arn = aws_iam_role.sns_can_firehose.arn
  raw_message_delivery  = true
}


resource "aws_iam_role" "firehose_role" {
  name = var.task_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_kinesis_firehose_delivery_stream" "stream" {
  name        = var.task_name
  destination = "s3"

  s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = data.aws_s3_bucket.bucket.arn
    prefix     = var.bucket_prefix
  }

}

data "aws_region" "current" {}
data "aws_caller_identity" "me" {}

module "cloudwatch_logs" {
  source         = "./..//terraform-aws-piab-log-group"
  name           = "${var.task_name}Logs"
  retention_days = 7
}

resource "aws_iam_role_policy" "policy" {
  name   = var.task_name
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement":
    [
        {
            "Effect": "Allow",
            "Action": [
                "s3:AbortMultipartUpload",
                "s3:GetBucketLocation",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:ListBucketMultipartUploads",
                "s3:PutObject"
            ],
            "Resource": [
                "${data.aws_s3_bucket.bucket.arn}",
                "${data.aws_s3_bucket.bucket.arn}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "kinesis:DescribeStream",
                "kinesis:GetShardIterator",
                "kinesis:GetRecords",
                "kinesis:ListShards"
            ],
            "Resource": "arn:aws:kinesis:${data.aws_region.current.name}:${data.aws_caller_identity.me.account_id}:stream/${data.aws_s3_bucket.bucket.arn}"
        },
        {
           "Effect": "Allow",
           "Action": [
               "logs:PutLogEvents"
           ],
           "Resource": [
               "${module.cloudwatch_logs.log_group.arn}:*"
           ]
        }
    ]
}
EOF
  role   = aws_iam_role.firehose_role.id
}