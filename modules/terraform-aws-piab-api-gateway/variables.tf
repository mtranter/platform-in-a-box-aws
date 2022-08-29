variable "api_name" {
  type        = string
  description = "The name of this API"
}

variable "openapi_spec" {
  type        = string
  description = "(optional) The Open API Spec body"
  default     = null
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
