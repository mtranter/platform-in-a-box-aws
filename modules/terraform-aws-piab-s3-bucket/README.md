## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.28.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_kms_alias.alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_lifecycle_configuration.lifecycle](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_logging.logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_public_access_block.block_public_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.versioning_example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_caller_identity.me](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_logs"></a> [access\_logs](#input\_access\_logs) | n/a | <pre>object({<br>    target_bucket = string<br>    target_prefix = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_bucket"></a> [bucket](#input\_bucket) | n/a | `string` | n/a | yes |
| <a name="input_lifecycle_transitions"></a> [lifecycle\_transitions](#input\_lifecycle\_transitions) | n/a | <pre>set(object({<br>    id                                     = string<br>    prefix                                 = optional(string)<br>    tags                                   = optional(map(string))<br>    abort_incomplete_multipart_upload_days = optional(bool)<br>    expiration = optional(object({<br>      date                         = optional(string)<br>      days                         = optional(number)<br>      expired_object_delete_marker = optional(string)<br>    }))<br>    transition = optional(object({<br>      date          = optional(string)<br>      days          = optional(number)<br>      storage_class = string<br>    }))<br>    noncurrent_version_expiration = optional(object({<br>      days = number<br>    }))<br>    noncurrent_version_transition = optional(object({<br>      days          = number<br>      storage_class = string<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_use_custom_kms"></a> [use\_custom\_kms](#input\_use\_custom\_kms) | n/a | `bool` | `true` | no |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | n/a | `bool` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket"></a> [bucket](#output\_bucket) | n/a |
| <a name="output_kms_key"></a> [kms\_key](#output\_kms\_key) | n/a |
| <a name="output_kms_key_alias"></a> [kms\_key\_alias](#output\_kms\_key\_alias) | n/a |
