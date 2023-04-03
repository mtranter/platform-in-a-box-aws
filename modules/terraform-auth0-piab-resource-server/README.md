## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_auth0"></a> [auth0](#requirement\_auth0) | >= 0.45.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_auth0"></a> [auth0](#provider\_auth0) | 0.45.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [auth0_resource_server.api](https://registry.terraform.io/providers/auth0/auth0/latest/docs/resources/resource_server) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_offline_access"></a> [allow\_offline\_access](#input\_allow\_offline\_access) | n/a | `bool` | n/a | yes |
| <a name="input_audience_name"></a> [audience\_name](#input\_audience\_name) | n/a | `string` | n/a | yes |
| <a name="input_scopes"></a> [scopes](#input\_scopes) | n/a | <pre>set(object({<br>    value       = string<br>    description = string<br>  }))</pre> | `[]` | no |
| <a name="input_server_name"></a> [server\_name](#input\_server\_name) | Name of this resource server/api | `string` | n/a | yes |
| <a name="input_signing_alg"></a> [signing\_alg](#input\_signing\_alg) | n/a | `string` | `"RS256"` | no |
| <a name="input_skip_consent_for_verifiable_first_party_clients"></a> [skip\_consent\_for\_verifiable\_first\_party\_clients](#input\_skip\_consent\_for\_verifiable\_first\_party\_clients) | n/a | `bool` | n/a | yes |
| <a name="input_token_lifetime"></a> [token\_lifetime](#input\_token\_lifetime) | n/a | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_server"></a> [resource\_server](#output\_resource\_server) | n/a |
