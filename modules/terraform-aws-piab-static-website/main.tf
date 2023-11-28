locals {
  full_domain_name = "${var.subdomain}.${var.zone_domain}"
  bucket_name      = local.full_domain_name
  s3_origin_id     = "s3-origin-website"
}

data "aws_route53_zone" "this" {
  name = var.zone_domain
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4"

  providers = {
    aws = aws.useast1
  }

  domain_name       = local.full_domain_name
  zone_id           = data.aws_route53_zone.this.id
  validation_method = "DNS"

}

resource "aws_route53_record" "alias" {
  count   = var.create_route53_records ? 1 : 0
  name    = local.full_domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.this.zone_id
  alias {
    name                   = aws_cloudfront_distribution.cf_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.cf_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

#############
# S3
#############
module "website" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3"

  bucket        = local.bucket_name
  attach_policy = true
  policy        = data.aws_iam_policy_document.s3_bucket_policy.json

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#############
# Cloudfront
#############
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "Identity for website ${local.full_domain_name}"
}

resource "aws_cloudfront_distribution" "cf_distribution" {
  origin {
    domain_name = module.website.s3_bucket_bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  dynamic "origin" {
    for_each = var.additional_cloudfront_behaviors
    content {
      domain_name = origin.value.domain_name
      origin_id   = origin.value.origin_id

      custom_origin_config {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = coalesce(origin.value.origin_protocol_policy, "https-only")
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }

  aliases = [local.full_domain_name]

  enabled         = true
  is_ipv6_enabled = true

  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.additional_cloudfront_behaviors
    content {
      allowed_methods  = coalesce(ordered_cache_behavior.value.allowed_methods, ["GET", "HEAD", "OPTIONS"])
      cached_methods   = coalesce(ordered_cache_behavior.value.cached_methods, ["GET", "HEAD", "OPTIONS"])
      target_origin_id = ordered_cache_behavior.value.origin_id
      path_pattern     = ordered_cache_behavior.value.path_pattern

      viewer_protocol_policy   = "redirect-to-https"
      min_ttl                  = ordered_cache_behavior.value.min_ttl
      default_ttl              = ordered_cache_behavior.value.default_ttl
      max_ttl                  = ordered_cache_behavior.value.max_ttl
      compress                 = ordered_cache_behavior.value.compress
      cache_policy_id          = coalesce(ordered_cache_behavior.value.cache_policy_id, "4135ea2d-6df8-44a3-9df3-4b5a84be39ad")
      origin_request_policy_id = ordered_cache_behavior.value.origin_request_policy_id
    }
  }

  price_class = var.cloudfront_priceclass

  viewer_certificate {
    acm_certificate_arn      = module.acm.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }

  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
