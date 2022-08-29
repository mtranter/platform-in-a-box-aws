locals {
  max_connect_config = {
    "1"   = 90
    "2"   = 180
    "4"   = 270
    "8"   = 1000
    "16"  = 2000
    "32"  = 3000
    "64"  = 4000
    "128" = 5000
    "192" = 5500
    "256" = 6000
    "384" = 6500
  }
  max_connections = local.max_connect_config[tostring(var.scaling_configuration.max_capacity)]
}

module "db_connections" {

  count   = var.alert_config.max_connections_pct != null ? 1 : 0
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 2.0"

  alarm_name          = "aurora-serverless${var.name}-max-connections"
  alarm_description   = "Aurora Serverlesss DB ${var.name} has exceeded configured max connections threshold"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = local.max_connections * (var.alert_config.max_connections_pct / 100)
  period              = 60
  unit                = "Percent"

  namespace   = "AWS/RDS"
  metric_name = "DatabaseConnections"
  statistic   = "Maximum"

  dimensions = {
    DBInstanceIdentifier = aws_rds_cluster.rds.id
  }

  alarm_actions = var.alert_config.alert_topics
}

module "max_cpu_alarm" {

  count   = var.alert_config.max_cpu_utilization_pct != null ? 1 : 0
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 2.0"

  alarm_name          = "dynamodb-table-${var.name}-read-throttles"
  alarm_description   = "Aurora Serverlesss DB ${var.name} has exceeded configured max CPU Utilization threshold"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = var.alert_config.max_cpu_utilization_pct
  period              = 60
  unit                = "Count"

  namespace   = "AWS/RDS"
  metric_name = "CPUUtilization"
  statistic   = "Maximum"

  dimensions = {
    DBInstanceIdentifier = aws_rds_cluster.rds.id
  }

  alarm_actions = var.alert_config.alert_topics
}
