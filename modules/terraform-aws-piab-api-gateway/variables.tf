variable "api_name" {
  type        = string
  description = "The name of this API"
}

variable "live_stage_name" {
  type        = string
  default     = "live"
  description = "The name of the API Gateway stage used for live."
}

variable "openapi_spec" {
  type        = string
  description = "(optional) The Open API Spec body"
  default     = null
}

variable "alarm_on_500" {
  type        = bool
  description = "If true, a CloudWatch alert will fire for 500 errors"
}

variable "alert_topics" {
  type        = list(string)
  description = "(optional) A list of SNS Topic ARNs that will broadcast any cloudwatch alarms"
  default     = null
}

variable "create_health_check" {
  type        = bool
  description = "(optional) if true, and if open_api_spec = null, creates a healthcheck endpoint"
}

variable "healthcheck_config" {
  type = object({
    path    = string
    enabled = bool
  })
  description = "(optional) describe your variable"
  default = {
    enabled = false
    path    = "__health"
  }
}
