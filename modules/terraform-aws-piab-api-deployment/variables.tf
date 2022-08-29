variable "api_name" {
  type        = string
  description = "(optional) describe your variable"
}

variable "live_stage_name" {
  type        = string
  default     = "live"
  description = "The name of the API Gateway stage used for live."
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
