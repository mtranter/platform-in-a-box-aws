## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.23.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | terraform-aws-modules/acm/aws | ~> 4 |
| <a name="module_website"></a> [website](#module\_website) | terraform-aws-modules/s3-bucket/aws | ~> 3 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.cf_distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_identity.oai](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity) | resource |
| [aws_route53_record.alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_iam_policy_document.s3_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_cloudfront_behaviors"></a> [additional\_cloudfront\_behaviors](#input\_additional\_cloudfront\_behaviors) | Additional CloudFront behaviors to add to the distribution | <pre>list(object({<br>    origin_id                = string<br>    domain_name              = string<br>    path_pattern             = string<br>    origin_protocol_policy   = optional(string)<br>    allowed_methods          = optional(list(string))<br>    cached_methods           = optional(list(string))<br>    min_ttl                  = optional(number)<br>    default_ttl              = optional(number)<br>    max_ttl                  = optional(number)<br>    cache_policy_id          = optional(string)<br>    compress                 = optional(bool)<br>    origin_request_policy_id = optional(string)<br><br>  }))</pre> | `[]` | no |
| <a name="input_cloudfront_priceclass"></a> [cloudfront\_priceclass](#input\_cloudfront\_priceclass) | n/a | `string` | `"PriceClass_All"` | no |
| <a name="input_create_route53_records"></a> [create\_route53\_records](#input\_create\_route53\_records) | Whether to create Route53 records for the CloudFront distribution | `bool` | `true` | no |
| <a name="input_subdomain"></a> [subdomain](#input\_subdomain) | The subdomain to use for the zone | `string` | n/a | yes |
| <a name="input_zone_domain"></a> [zone\_domain](#input\_zone\_domain) | The domain name of the zone | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | n/a |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | n/a |
