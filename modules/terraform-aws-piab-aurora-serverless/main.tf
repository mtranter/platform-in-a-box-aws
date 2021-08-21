terraform {
  experiments = [module_variable_optional_attrs]
}


locals {
  port   = var.aurora_engine == "postgresql" ? 5432 : 3306
  engine = "aurora-${var.aurora_engine}"
}

data "aws_rds_engine_version" "version" {
  engine  = local.engine
  version = var.engine_version
}

resource "random_id" "snapshot_identifier" {

  keepers = {
    id = var.name
  }

  byte_length = 4
}

resource "aws_db_subnet_group" "default" {
  name       = var.name
  subnet_ids = var.subnet_ids
}

resource "aws_rds_cluster_parameter_group" "default" {
  count       = length(var.db_parameters)
  name        = var.name
  family      = "aurora5.6"
  description = "RDS default cluster parameter group"

  dynamic "parameter" {
    for_each = var.db_parameters
    content {
      name  = parameter.key
      value = parameter.value
    }
  }
}

resource "aws_rds_cluster" "rds" {

  cluster_identifier = var.name

  engine                              = local.engine
  engine_mode                         = "serverless"
  engine_version                      = var.engine_version
  enable_http_endpoint                = var.enable_http_endpoint
  kms_key_id                          = aws_kms_key.key.id
  database_name                       = var.name
  master_username                     = var.master_username
  master_password                     = var.master_password
  final_snapshot_identifier           = "${var.name}-${random_id.snapshot_identifier.hex}"
  skip_final_snapshot                 = var.skip_final_snapshot
  deletion_protection                 = var.deletion_protection
  backup_retention_period             = var.backup_retention_period
  port                                = local.port
  db_subnet_group_name                = aws_db_subnet_group.default.name
  vpc_security_group_ids              = [aws_security_group.this.id]
  storage_encrypted                   = true
  db_cluster_parameter_group_name     = length(var.allowed_security_group_ids) > 0 ? aws_rds_cluster_parameter_group.default[0].name : null
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  enabled_cloudwatch_logs_exports     = var.enabled_cloudwatch_logs_exports

  scaling_configuration {
    auto_pause               = var.scaling_configuration.auto_pause
    max_capacity             = var.scaling_configuration.max_capacity
    min_capacity             = var.scaling_configuration.min_capacity
    seconds_until_auto_pause = var.scaling_configuration.seconds_until_auto_pause
    timeout_action           = var.scaling_configuration.timeout_action
  }

  lifecycle {
    create_before_destroy = true
  }

}


data "aws_subnet" "subnet" {
  id = var.subnet_ids[0]
}
################################################################################
# Security Group
################################################################################

resource "aws_security_group" "this" {

  name_prefix = "${var.name}-"
  vpc_id      = data.aws_subnet.subnet.vpc_id
  description = "Control traffic to/from Aurora Serverless ${var.name}"

}

resource "aws_security_group_rule" "default_ingress" {
  count = length(var.allowed_security_group_ids)

  description = "From allowed Security groups"

  type                     = "ingress"
  from_port                = local.port
  to_port                  = local.port
  protocol                 = "tcp"
  source_security_group_id = element(var.allowed_security_group_ids, count.index)
  security_group_id        = aws_security_group.this.id
}
