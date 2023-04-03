## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_auth0"></a> [auth0](#requirement\_auth0) | >= 0.21.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_auth0"></a> [auth0](#provider\_auth0) | 0.21.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [auth0_client.app](https://registry.terraform.io/providers/alexkappa/auth0/latest/docs/resources/client) | resource |
| [auth0_client_grant.client_grant](https://registry.terraform.io/providers/alexkappa/auth0/latest/docs/resources/client_grant) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_origins"></a> [allowed\_origins](#input\_allowed\_origins) | n/a | `list(string)` | n/a | yes |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | n/a | `string` | n/a | yes |
| <a name="input_client_grants"></a> [client\_grants](#input\_client\_grants) | n/a | <pre>list(object({<br>    audience = string<br>    scopes   = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_grant_types"></a> [grant\_types](#input\_grant\_types) | n/a | `list(string)` | <pre>[<br>  "authorization_code",<br>  "implicit",<br>  "refresh_token"<br>]</pre> | no |
| <a name="input_jwt_alg"></a> [jwt\_alg](#input\_jwt\_alg) | n/a | `string` | `"RS256"` | no |
| <a name="input_jwt_lifetime_seconds"></a> [jwt\_lifetime\_seconds](#input\_jwt\_lifetime\_seconds) | n/a | `number` | `300` | no |
| <a name="input_jwt_secret_encoded"></a> [jwt\_secret\_encoded](#input\_jwt\_secret\_encoded) | n/a | `bool` | `false` | no |
| <a name="input_login_callback_path"></a> [login\_callback\_path](#input\_login\_callback\_path) | n/a | `string` | n/a | yes |
| <a name="input_logout_callback_path"></a> [logout\_callback\_path](#input\_logout\_callback\_path) | n/a | `string` | n/a | yes |
| <a name="input_refresh_expiration_type"></a> [refresh\_expiration\_type](#input\_refresh\_expiration\_type) | n/a | `string` | `"expiring"` | no |
| <a name="input_refresh_idle_token_lifetime"></a> [refresh\_idle\_token\_lifetime](#input\_refresh\_idle\_token\_lifetime) | n/a | `number` | `1296000` | no |
| <a name="input_refresh_infinite_idle_token_lifetime"></a> [refresh\_infinite\_idle\_token\_lifetime](#input\_refresh\_infinite\_idle\_token\_lifetime) | n/a | `bool` | `false` | no |
| <a name="input_refresh_infinite_token_lifetime"></a> [refresh\_infinite\_token\_lifetime](#input\_refresh\_infinite\_token\_lifetime) | n/a | `bool` | `false` | no |
| <a name="input_refresh_leeway"></a> [refresh\_leeway](#input\_refresh\_leeway) | n/a | `number` | `15` | no |
| <a name="input_refresh_rotation_type"></a> [refresh\_rotation\_type](#input\_refresh\_rotation\_type) | n/a | `string` | `"rotating"` | no |
| <a name="input_refresh_token_lifetime"></a> [refresh\_token\_lifetime](#input\_refresh\_token\_lifetime) | n/a | `number` | `2592000` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client"></a> [client](#output\_client) | n/a |
