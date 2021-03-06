variable "api_name" {
  type        = string
  description = "The name of this API"
}

variable "live_stage_name" {
  type        = string
  default     = "live"
  description = "The name of the API Gateway stage used for live."
}

variable "api_openapi_spec" {
  type        = string
  description = "The Open API Spec body"
}

variable "alarm_on_500" {
  type        = bool
  description = "If true, a CloudWatch alert will fire for 500 errors"
}