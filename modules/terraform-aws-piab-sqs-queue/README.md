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
| <a name="module_dlq_alarm"></a> [dlq\_alarm](#module\_dlq\_alarm) | terraform-aws-modules/cloudwatch/aws//modules/metric-alarm | ~> 2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_kms_alias.alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_sqs_queue.dead_letter_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [aws_caller_identity.me](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.key_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alert_on_dlq"></a> [alert\_on\_dlq](#input\_alert\_on\_dlq) | Create a cloudwatch alert if messages are sent to the Dead Letter Queue | `bool` | `true` | no |
| <a name="input_alert_topics"></a> [alert\_topics](#input\_alert\_topics) | (optional) List of SNS topic arns that will be used to broadcast Cloudwatch Alarms | `list(string)` | `null` | no |
| <a name="input_content_based_deduplication"></a> [content\_based\_deduplication](#input\_content\_based\_deduplication) | n/a | `bool` | `null` | no |
| <a name="input_create_dlq"></a> [create\_dlq](#input\_create\_dlq) | If true, will create a DLQ for this queue | `bool` | `true` | no |
| <a name="input_deduplication_scope"></a> [deduplication\_scope](#input\_deduplication\_scope) | The deduplication scope. Either `messageGroup` or `queue` | `string` | `"messageGroup"` | no |
| <a name="input_delay_seconds"></a> [delay\_seconds](#input\_delay\_seconds) | The queue delay seconds. Default 0 | `number` | `0` | no |
| <a name="input_fifo_throughput_limit"></a> [fifo\_throughput\_limit](#input\_fifo\_throughput\_limit) | The fifo throughput limit. Either `perMessageGroupId` or `perQueue` | `string` | `"perMessageGroupId"` | no |
| <a name="input_is_fifo"></a> [is\_fifo](#input\_is\_fifo) | Creates a FIFO queue if set | `bool` | n/a | yes |
| <a name="input_kms_policy_source_json"></a> [kms\_policy\_source\_json](#input\_kms\_policy\_source\_json) | An additional policy to add to the KMS Key that will be used to encrypt this data | `string` | `null` | no |
| <a name="input_max_receive_count"></a> [max\_receive\_count](#input\_max\_receive\_count) | Maximum retries before moving a message to dlq. Default 100 | `number` | `100` | no |
| <a name="input_message_retention_seconds"></a> [message\_retention\_seconds](#input\_message\_retention\_seconds) | The number of seconds for which a message will be retained | `number` | `1209600` | no |
| <a name="input_queue_name"></a> [queue\_name](#input\_queue\_name) | Queue name. '.fifo' will be appended to the name if is\_fifo = true | `string` | n/a | yes |
| <a name="input_queue_policy_json"></a> [queue\_policy\_json](#input\_queue\_policy\_json) | The queue access policy json. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `null` | no |
| <a name="input_visibility_timeout_seconds"></a> [visibility\_timeout\_seconds](#input\_visibility\_timeout\_seconds) | The visibility timeout in seconds | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dlq"></a> [dlq](#output\_dlq) | n/a |
| <a name="output_queue"></a> [queue](#output\_queue) | n/a |
