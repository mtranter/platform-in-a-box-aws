locals {
  log_group_name = "/aws/api-gateway-stage/${aws_api_gateway_rest_api.api.name}-${var.live_stage_name}/access-logs"
}

resource "aws_api_gateway_rest_api" "api" {
  name = var.api_name
  body = var.api_openapi_spec
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

module "log_group" {
  source = "./../terraform-aws-piab-log-group"
  name   = local.log_group_name
}

resource "aws_api_gateway_stage" "default_stage" {
  deployment_id        = aws_api_gateway_deployment.deployment.id
  rest_api_id          = aws_api_gateway_rest_api.api.id
  stage_name           = var.live_stage_name
  xray_tracing_enabled = true

  access_log_settings {
    destination_arn = module.log_group.log_group.arn
    format = replace(<<EOF
{ "requestId":"$context.requestId",
  "ip": "$context.identity.sourceIp",
  "caller":"$context.identity.caller",
  "user":"$context.identity.user",
  "requestTime":"$context.requestTime",
  "httpMethod":"$context.httpMethod",
  "resourcePath":"$context.resourcePath",
  "path":"$context.path",
  "status":"$context.status",
  "protocol":"$context.protocol",
  "error": "$context.error.message",
  "integrationError": "$context.integrationErrorMessage",
  "xrayTraceId": "$context.xrayTraceId",
  "integrationLatency": "$context.integration.latency",
  "responseLatency": "$context.responseLatency"
}
EOF
    , "\n", "")
  }
}

resource "aws_api_gateway_method_settings" "api_settings" {
  method_path = "*/*"
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.default_stage.stage_name

  #tfsec:ignore:aws-api-gateway-enable-cache-encryption Cache not enabled
  settings {
    logging_level      = "INFO"
    metrics_enabled    = true
    data_trace_enabled = true
  }
}

module "alarm_500s" {

  count   = var.alarm_on_500 ? 1 : 0
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 2.0"

  alarm_name          = "api-gw${var.api_name}"
  alarm_description   = "Api Gateway ${var.api_name} returned a 500"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 1
  period              = 60
  unit                = "Count"

  namespace   = "AWS/ApiGateway"
  metric_name = "5XXError"
  statistic   = "Maximum"

  dimensions = {
    ApiName = var.api_name
    Stage   = var.live_stage_name
  }

  alarm_actions = var.alert_topics
}
