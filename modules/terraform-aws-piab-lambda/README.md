## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.12.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dlq"></a> [dlq](#module\_dlq) | ./..//terraform-aws-piab-sqs-queue | n/a |
| <a name="module_dlq_alarm"></a> [dlq\_alarm](#module\_dlq\_alarm) | terraform-aws-modules/cloudwatch/aws//modules/metric-alarm | ~> 2.0 |
| <a name="module_dlq_failed_alarm"></a> [dlq\_failed\_alarm](#module\_dlq\_failed\_alarm) | terraform-aws-modules/cloudwatch/aws//modules/metric-alarm | ~> 2.0 |
| <a name="module_errors_alarm"></a> [errors\_alarm](#module\_errors\_alarm) | terraform-aws-modules/cloudwatch/aws//modules/metric-alarm | ~> 2.0 |
| <a name="module_log_group"></a> [log\_group](#module\_log\_group) | ./..//terraform-aws-piab-log-group | n/a |
| <a name="module_max_duration_alarm"></a> [max\_duration\_alarm](#module\_max\_duration\_alarm) | terraform-aws-modules/cloudwatch/aws//modules/metric-alarm | ~> 2.0 |
| <a name="module_throttles_alarm"></a> [throttles\_alarm](#module\_throttles\_alarm) | terraform-aws-modules/cloudwatch/aws//modules/metric-alarm | ~> 2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.every_five_minutes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.check_every_five_minutes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_role.iam_for_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.can_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.dlq_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.aws_xray_write_only_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.enhanced_monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.iam_for_lambda_role_eni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.insights_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_alias.lambda_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_alias) | resource |
| [aws_lambda_function.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_layer_version.layers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_layer_version) | resource |
| [aws_lambda_permission.allow_cloudwatch_to_call_check_foo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_provisioned_concurrency_config.provisioned_concurrency](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_provisioned_concurrency_config) | resource |
| [aws_iam_policy_document.allow_dlq_kms_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.can_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.can_sqs_dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alert_config"></a> [alert\_config](#input\_alert\_config) | Configuration for Cloudwatch alarms. e.g<br>alert\_config = {<br>    on\_error       = true<br>    on\_throttle    = true<br>    on\_dlq         = true<br>    on\_dlq\_failure = true<br>    max\_duration   = 500 // Will alarm if invocation duration exceeds this value<br>    alert\_topic\_arn = "arn:aws:sns:eu-west-1:123456789:my-sns-topic"<br>} | <pre>object({<br>    on_error       = bool<br>    on_throttle    = bool<br>    on_dlq         = bool<br>    on_dlq_failure = bool<br>    max_duration   = optional(number)<br>    alert_topics   = optional(list(string))<br>  })</pre> | <pre>{<br>  "alert_topics": null,<br>  "max_duration": null,<br>  "on_dlq": true,<br>  "on_dlq_failure": true,<br>  "on_error": true,<br>  "on_throttle": true<br>}</pre> | no |
| <a name="input_create_dlq"></a> [create\_dlq](#input\_create\_dlq) | Create a dead letter queue for this function | `bool` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | n/a | `string` | `null` | no |
| <a name="input_enable_lambda_insights"></a> [enable\_lambda\_insights](#input\_enable\_lambda\_insights) | Enable lambda insights | `bool` | `true` | no |
| <a name="input_environment_vars"></a> [environment\_vars](#input\_environment\_vars) | The environment variables to set for the function | `map(string)` | `{}` | no |
| <a name="input_file_system_config"></a> [file\_system\_config](#input\_file\_system\_config) | EFS mount config for this function. e.g.<br>file\_system\_config = {<br>  efs\_access\_point\_arn = module.efs.arn<br>  local\_mount\_path = "/mnt/data"<br>} | <pre>object({<br>    efs_access_point_arn = string<br>    local_mount_path     = string<br>  })</pre> | `null` | no |
| <a name="input_filename"></a> [filename](#input\_filename) | The file containing the lambda code. | `string` | n/a | yes |
| <a name="input_handler"></a> [handler](#input\_handler) | The handler function | `string` | n/a | yes |
| <a name="input_keep_warm"></a> [keep\_warm](#input\_keep\_warm) | If true, a cloudwatch cron will trigger this function every 5 minutes to minimise cold starts | `bool` | `false` | no |
| <a name="input_layers"></a> [layers](#input\_layers) | A list of layer arns that the lambda function will use | `list(string)` | `[]` | no |
| <a name="input_layers_source"></a> [layers\_source](#input\_layers\_source) | A map of layer name to layer source | <pre>map(object({<br>    filename         = string<br>    source_code_hash = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | n/a | `number` | `512` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the function | `string` | n/a | yes |
| <a name="input_provisioned_concurrency"></a> [provisioned\_concurrency](#input\_provisioned\_concurrency) | Number of provisioned instances enabled for this function | `number` | `0` | no |
| <a name="input_publish"></a> [publish](#input\_publish) | Sets whether to publish creation/change as a new Lambda Function | `bool` | `true` | no |
| <a name="input_reserved_concurrency"></a> [reserved\_concurrency](#input\_reserved\_concurrency) | The reserved concurrency set for this function | `number` | `-1` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | n/a | `string` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | The service to which this lambda function belongs | `string` | `null` | no |
| <a name="input_source_code_hash"></a> [source\_code\_hash](#input\_source\_code\_hash) | n/a | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to add to the lambda | `map(string)` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | n/a | `number` | `3` | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | The config for the VPC to which this lambda is to be added. Defaults to null | <pre>object({<br>    subnet_ids         = list(string)<br>    security_group_ids = list(string)<br>  })</pre> | `null` | no |
| <a name="input_xray_enabled"></a> [xray\_enabled](#input\_xray\_enabled) | Enable XRay for this function | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alias"></a> [alias](#output\_alias) | n/a |
| <a name="output_execution_role"></a> [execution\_role](#output\_execution\_role) | n/a |
| <a name="output_function"></a> [function](#output\_function) | n/a |
| <a name="output_invoke_arn"></a> [invoke\_arn](#output\_invoke\_arn) | n/a |
| <a name="output_log_group"></a> [log\_group](#output\_log\_group) | n/a |
| <a name="output_qualifier"></a> [qualifier](#output\_qualifier) | n/a |
