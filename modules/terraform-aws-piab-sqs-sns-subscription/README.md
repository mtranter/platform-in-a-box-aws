## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.64.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dlq"></a> [dlq](#module\_dlq) | ./..//terraform-aws-piab-sqs-queue | n/a |
| <a name="module_sqs_sns_access"></a> [sqs\_sns\_access](#module\_sqs\_sns\_access) | ./..//terraform-aws-piab-sqs-sns-access-policies | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_sns_topic_subscription.subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_arn.queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/arn) | data source |
| [aws_arn.topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/arn) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_queue_policy"></a> [create\_queue\_policy](#input\_create\_queue\_policy) | In order for SNS to forward messages to SQS, the SQS policy must grant sqs:SendMessage to SNS.<br>This module will set this policy by default, however if you require a different policy on this queue,<br>set this flag to false. The default policy looks like this:<br>{<br>  "Version": "2012-10-17",<br>  "Id": "sqspolicy",<br>  "Statement": [<br>    {<br>      "Sid": "SNSCanSendToQueue",<br>      "Effect": "Allow",<br>      "Principal": "*",<br>      "Action": "sqs:SendMessage",<br>      "Resource": "<your queue arn>",<br>      "Condition": {<br>        "ArnEquals": {<br>          "aws:SourceArn": "<your topic arn>"<br>        }<br>      }<br>    }<br>  ]<br>} | `bool` | `true` | no |
| <a name="input_queue_policy_source_json"></a> [queue\_policy\_source\_json](#input\_queue\_policy\_source\_json) | See here: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#source_json | `string` | `null` | no |
| <a name="input_raw_message_delivery"></a> [raw\_message\_delivery](#input\_raw\_message\_delivery) | Enable raw message delivery | `bool` | `true` | no |
| <a name="input_sns_topic_arn"></a> [sns\_topic\_arn](#input\_sns\_topic\_arn) | The ARN of the topic to subscribe to | `string` | n/a | yes |
| <a name="input_sqs_queue_arn"></a> [sqs\_queue\_arn](#input\_sqs\_queue\_arn) | The ARN of the subscribing SQS Queue | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subscription"></a> [subscription](#output\_subscription) | n/a |
