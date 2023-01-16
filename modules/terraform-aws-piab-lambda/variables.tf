variable "environment_vars" {
  type        = map(string)
  default     = {}
  description = "The environment variables to set for the function"
}

variable "name" {
  type        = string
  description = "The name of the function"
}

variable "description" {
  type    = string
  default = null
}

variable "handler" {
  type        = string
  description = "The handler function"
}

variable "filename" {
  type        = string
  description = "The file containing the lambda code."
}

variable "source_code_hash" {
  type = string
  default = null
}

variable "timeout" {
  type    = number
  default = 3
}

variable "memory_size" {
  type    = number
  default = 512
}

variable "layers" {
  type        = list(string)
  default     = []
  description = "A list of layer arns that the lambda function will use"
}

variable "layers_source" {
  type = map(object({
    filename         = string
    source_code_hash = optional(string)
  }))
  description = "A map of layer name to layer source"
  default     = {}
}

variable "runtime" {
  type = string
}

variable "publish" {
  type        = bool
  description = "Sets whether to publish creation/change as a new Lambda Function"
  default     = true
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to add to the lambda"
}

variable "vpc_config" {
  type = object({
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })
  default     = null
  description = "The config for the VPC to which this lambda is to be added. Defaults to null"
}

variable "xray_enabled" {
  default     = true
  type        = bool
  description = "Enable XRay for this function"
}

variable "file_system_config" {
  type = object({
    efs_access_point_arn = string
    local_mount_path     = string
  })
  default     = null
  description = <<EOF
EFS mount config for this function. e.g.
file_system_config = {
  efs_access_point_arn = module.efs.arn
  local_mount_path = "/mnt/data"
}
EOF
}


variable "reserved_concurrency" {
  type        = number
  default     = -1
  description = "The reserved concurrency set for this function"
}

variable "keep_warm" {
  type        = bool
  default     = false
  description = "If true, a cloudwatch cron will trigger this function every 5 minutes to minimise cold starts"
}

variable "create_dlq" {
  type        = bool
  description = "Create a dead letter queue for this function"
}

variable "alert_config" {
  type = object({
    on_error       = bool
    on_throttle    = bool
    on_dlq         = bool
    on_dlq_failure = bool
    max_duration   = optional(number)
    alert_topics   = optional(list(string))
  })
  default = {
    on_error       = true
    on_throttle    = true
    on_dlq         = true
    on_dlq_failure = true
    max_duration   = null
    alert_topics   = null
  }
  description = <<EOF
Configuration for Cloudwatch alarms. e.g
alert_config = {
    on_error       = true
    on_throttle    = true
    on_dlq         = true
    on_dlq_failure = true
    max_duration   = 500 // Will alarm if invocation duration exceeds this value
    alert_topic_arn = "arn:aws:sns:eu-west-1:123456789:my-sns-topic"
}
EOF
}


variable "service_name" {
  type        = string
  description = "The service to which this lambda function belongs"
  default     = null
}

variable "enable_lambda_insights" {
  type        = bool
  default     = true
  description = <<EOF
Enable lambda insights
EOF
}

variable "provisioned_concurrency" {
  type        = number
  default     = 0
  description = <<EOF
Number of provisioned instances enabled for this function 
EOF
}
