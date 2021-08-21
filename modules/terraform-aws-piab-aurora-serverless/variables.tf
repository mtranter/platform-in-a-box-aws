variable "name" {
  type        = string
  description = "The name of this DB"
}

variable "enable_http_endpoint" {
  type        = bool
  description = "Enable RDS Data API"
  default     = true
}

variable "master_username" {
  type        = string
  default     = null
  description = "The master username for this instance"
}

variable "master_password" {
  type        = string
  default     = null
  description = "The master password for this instance"
}

variable "skip_final_snapshot" {
  type        = bool
  default     = false
  description = "Skip creating a final snapshot when this DB is deleted"
}

variable "deletion_protection" {
  type        = bool
  default     = true
  description = "Will protect this resource against deletion"
}

variable "backup_retention_period" {
  type        = number
  description = "The days to retain backups for."
  default     = 7
}

variable "aurora_engine" {
  type        = string
  description = "mysql or postgresql"
  validation {
    condition     = var.aurora_engine == "mysql" || var.aurora_engine == "postgresql"
    error_message = "The aurora_engine must be either mysql or postgresql."
  }
}

variable "engine_version" {
  type        = string
  description = "The engine version for this cluster. e.g. 13.6"
}

variable "subnet_ids" {
  type        = list(string)
  description = "The list of subnet ids into which this DB will be deployed"
}

variable "allowed_security_group_ids" {
  type        = list(string)
  description = "The list of security groups allowed to access this instance"
}

variable "iam_database_authentication_enabled" {
  type        = bool
  default     = true
  description = "Enable IAM auth for this DB"
}

variable "enabled_cloudwatch_logs_exports" {
  type        = set(string)
  default     = ["error", "slowquery"]
  description = "Set of log types to export to cloudwatch. If omitted, no logs will be exported. The following log types are supported: audit, error, general, slowquery, postgresql"
  validation {
    condition     = length([for v in var.enabled_cloudwatch_logs_exports : v if contains(["audit", "error", "general", "slowquery", "postgresql"], v)]) > 0
    error_message = "The variable enabled_cloudwatch_logs_exports must be one of audit, error, general, slowquery, postgresql."
  }
}

variable "db_parameters" {
  type        = map(string)
  description = "A map of key value pairs that will be created as a DB Parameter group: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithParamGroups.html"
  default     = {}
}

variable "scaling_configuration" {
  type = object({
    auto_pause               = bool
    max_capacity             = number
    min_capacity             = number
    seconds_until_auto_pause = optional(number)
    timeout_action           = optional(string)
  })
  description = "See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster#scaling_configuration-argument-reference"

}


variable "alert_config" {
  type = object({
    max_connections_pct     = number
    max_cpu_utilization_pct = number
  })

  default = {
    max_connections_pct     = 50
    max_cpu_utilization_pct = 50
  }
}