## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.12.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alarm_500s"></a> [alarm\_500s](#module\_alarm\_500s) | terraform-aws-modules/cloudwatch/aws//modules/metric-alarm | ~> 2.0 |
| <a name="module_log_group"></a> [log\_group](#module\_log\_group) | ./../terraform-aws-piab-log-group | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_deployment.deployment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_method_settings.api_settings](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_settings) | resource |
| [aws_api_gateway_rest_api.api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) | resource |
| [aws_api_gateway_stage.default_stage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_on_500"></a> [alarm\_on\_500](#input\_alarm\_on\_500) | If true, a CloudWatch alert will fire for 500 errors | `bool` | n/a | yes |
| <a name="input_alert_topics"></a> [alert\_topics](#input\_alert\_topics) | (optional) A list of SNS Topic ARNs that will broadcast any cloudwatch alarms | `list(string)` | `null` | no |
| <a name="input_api_name"></a> [api\_name](#input\_api\_name) | The name of this API | `string` | n/a | yes |
| <a name="input_api_openapi_spec"></a> [api\_openapi\_spec](#input\_api\_openapi\_spec) | The Open API Spec body | `string` | n/a | yes |
| <a name="input_live_stage_name"></a> [live\_stage\_name](#input\_live\_stage\_name) | The name of the API Gateway stage used for live. | `string` | `"live"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_logs_log_group"></a> [access\_logs\_log\_group](#output\_access\_logs\_log\_group) | n/a |
| <a name="output_api"></a> [api](#output\_api) | n/a |
| <a name="output_deployment"></a> [deployment](#output\_deployment) | n/a |
| <a name="output_live_stage"></a> [live\_stage](#output\_live\_stage) | n/a |
