## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.12.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy_document.allow_sns_kms_queue_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.queue_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_sns_topic_arn"></a> [sns\_topic\_arn](#input\_sns\_topic\_arn) | The ARN of the SNS topic that that SQS queue will subscribe to | `string` | n/a | yes |
| <a name="input_sqs_queue_arn"></a> [sqs\_queue\_arn](#input\_sqs\_queue\_arn) | The queue arn | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_policy"></a> [kms\_policy](#output\_kms\_policy) | The value to use for the kms\_policy\_source\_json argument when creating an SQS queue with PIAB |
| <a name="output_queue_policy"></a> [queue\_policy](#output\_queue\_policy) | The value to use for the queue\_policy\_json argument when creating an SQS queue with PIAB |
