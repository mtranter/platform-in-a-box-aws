variable "zone_domain" {
  type        = string
  description = "The domain name of the zone"
}

variable "subdomain" {
  type        = string
  description = "The subdomain to use for the zone"
}

variable "cloudfront_priceclass" {
  type    = string
  default = "PriceClass_All"
  validation {
    condition     = contains(["PriceClass_100", "PriceClass_200", "PriceClass_All"], var.cloudfront_priceclass)
    error_message = "Invalid CloudFront price class"
  }
}

variable "create_route53_records" {
  type        = bool
  description = "Whether to create Route53 records for the CloudFront distribution"
  default     = true
}

variable "additional_cloudfront_behaviors" {
  type = list(object({
    origin_id                = string
    domain_name              = string
    path_pattern             = string
    origin_protocol_policy   = optional(string)
    allowed_methods          = optional(list(string))
    cached_methods           = optional(list(string))
    min_ttl                  = optional(number)
    default_ttl              = optional(number)
    max_ttl                  = optional(number)
    cache_policy_id          = optional(string)
    compress                 = optional(bool)
    origin_request_policy_id = optional(string)

  }))
  description = "Additional CloudFront behaviors to add to the distribution"
  default     = []
}
