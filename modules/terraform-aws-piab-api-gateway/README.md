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
| <a name="module_healthcheck"></a> [healthcheck](#module\_healthcheck) | ./health-check | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_rest_api.api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_name"></a> [api\_name](#input\_api\_name) | The name of this API | `string` | n/a | yes |
| <a name="input_healthcheck_config"></a> [healthcheck\_config](#input\_healthcheck\_config) | (optional) describe your variable | <pre>object({<br>    path    = string<br>    enabled = bool<br>  })</pre> | <pre>{<br>  "enabled": false,<br>  "path": "__health"<br>}</pre> | no |
| <a name="input_openapi_spec"></a> [openapi\_spec](#input\_openapi\_spec) | (optional) The Open API Spec body | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api"></a> [api](#output\_api) | n/a |
