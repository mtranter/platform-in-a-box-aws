module "errors_alarm" {

  count   = var.alert_config.on_error ? 1 : 0
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 2.0"

  alarm_name          = "lambda-errors-${aws_lambda_function.lambda.function_name}"
  alarm_description   = "Lambda function ${aws_lambda_function.lambda.function_name} has thrown an error"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 1
  period              = 60
  unit                = "Count"

  namespace   = "AWS/Lambda"
  metric_name = "Errors"
  statistic   = "Maximum"

  dimensions = {
    FunctionName = aws_lambda_function.lambda.function_name
  }
}

module "throttles_alarm" {

  count   = var.alert_config.on_throttle ? 1 : 0
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 2.0"

  alarm_name          = "lambda-throttles-${aws_lambda_function.lambda.function_name}"
  alarm_description   = "Lambda function ${aws_lambda_function.lambda.function_name} has been throttled"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 1
  period              = 60
  unit                = "Count"

  namespace   = "AWS/Lambda"
  metric_name = "Throttles"
  statistic   = "Maximum"

  dimensions = {
    FunctionName = aws_lambda_function.lambda.function_name
  }
}


module "dlq_alarm" {

  count   = var.alert_config.on_dlq && var.create_dlq ? 1 : 0
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 2.0"

  alarm_name          = "lambda-dlq-${aws_lambda_function.lambda.function_name}"
  alarm_description   = "Lambda function ${aws_lambda_function.lambda.function_name} has published a message to its dead letter queue"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 1
  period              = 60
  unit                = "Count"

  namespace   = "AWS/SQS"
  metric_name = "NumberOfMessagesReceived"
  statistic   = "Maximum"

  dimensions = {
    QueueName = module.dlq[0].queue.name
  }
}

module "dlq_failed_alarm" {

  count   = var.alert_config.max_duration != null ? 1 : 0
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 2.0"

  alarm_name          = "lambda-dlq-failed-${aws_lambda_function.lambda.function_name}"
  alarm_description   = "Lambda function ${aws_lambda_function.lambda.function_name} was unable to publish a failed event to DLQ"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 1
  period              = 60
  unit                = "Count"

  namespace   = "AWS/Lambda"
  metric_name = "DeadLetterErrors"
  statistic   = "Maximum"

  dimensions = {
    FunctionName = aws_lambda_function.lambda.function_name
  }
}


module "max_duration_alarm" {

  count   = var.alert_config.max_duration != null ? 1 : 0
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 2.0"

  alarm_name          = "lambda-dlq-failed-${aws_lambda_function.lambda.function_name}"
  alarm_description   = "Lambda function ${aws_lambda_function.lambda.function_name} duration exceeded max duration of ${var.alert_config.max_duration}ms"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = var.alert_config.max_duration
  period              = 60
  unit                = "Count"

  namespace   = "AWS/Lambda"
  metric_name = "Duration"
  statistic   = "Maximum"

  dimensions = {
    FunctionName = aws_lambda_function.lambda.function_name
  }
}