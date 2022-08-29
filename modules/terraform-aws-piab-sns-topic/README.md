## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.15.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_errors_alarm"></a> [errors\_alarm](#module\_errors\_alarm) | terraform-aws-modules/cloudwatch/aws//modules/metric-alarm | ~> 2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.failures_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.can_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_kms_alias.alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_sns_topic.topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_caller_identity.me](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.can_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.key_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.topic_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alert_topics"></a> [alert\_topics](#input\_alert\_topics) | (optional) List of SNS topic arns that will be used to broadcast Cloudwatch Alarms | `list(string)` | `null` | no |
| <a name="input_content_based_deduplication"></a> [content\_based\_deduplication](#input\_content\_based\_deduplication) | Use Content based deduplication for a FIFO queue | `bool` | `null` | no |
| <a name="input_is_fifo"></a> [is\_fifo](#input\_is\_fifo) | Create a FIFO queue | `bool` | n/a | yes |
| <a name="input_key_policy_sources"></a> [key\_policy\_sources](#input\_key\_policy\_sources) | An IAM policy that will be merged with the KMS Key policy for this topic<br>See here: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#source_policy_documents | `list(string)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Any tags for this queue | `map(string)` | `null` | no |
| <a name="input_topic_name"></a> [topic\_name](#input\_topic\_name) | The name of this topic. If it is a FIFO topic, '.fifo' will be appended to the name | `string` | n/a | yes |
| <a name="input_topic_policy_sources"></a> [topic\_policy\_sources](#input\_topic\_policy\_sources) | An IAM policy that will be merged with the Topic policy<br>See here: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#source_policy_documents | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key"></a> [kms\_key](#output\_kms\_key) | n/a |
| <a name="output_kms_key_alias"></a> [kms\_key\_alias](#output\_kms\_key\_alias) | n/a |
| <a name="output_topic"></a> [topic](#output\_topic) | n/a |
