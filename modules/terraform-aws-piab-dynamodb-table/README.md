## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.9.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_conditional_check_failed_alarm"></a> [conditional\_check\_failed\_alarm](#module\_conditional\_check\_failed\_alarm) | terraform-aws-modules/cloudwatch/aws//modules/metric-alarm | ~> 2.0 |
| <a name="module_read_throttles_alarm"></a> [read\_throttles\_alarm](#module\_read\_throttles\_alarm) | terraform-aws-modules/cloudwatch/aws//modules/metric-alarm | ~> 2.0 |
| <a name="module_system_errors_alarm"></a> [system\_errors\_alarm](#module\_system\_errors\_alarm) | terraform-aws-modules/cloudwatch/aws//modules/metric-alarm | ~> 2.0 |
| <a name="module_transaction_conflict_alarm"></a> [transaction\_conflict\_alarm](#module\_transaction\_conflict\_alarm) | terraform-aws-modules/cloudwatch/aws//modules/metric-alarm | ~> 2.0 |
| <a name="module_write_throttles_alarm"></a> [write\_throttles\_alarm](#module\_write\_throttles\_alarm) | terraform-aws-modules/cloudwatch/aws//modules/metric-alarm | ~> 2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_kms_alias.alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_caller_identity.me](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alert_config"></a> [alert\_config](#input\_alert\_config) | Configuration for Cloudwatch alarms. e.g<br>alert\_config = {<br>    on\_conditional\_check\_failed\_per\_minute = null<br>    on\_read\_throttles\_per\_minute           = 10<br>    on\_write\_throttles\_per\_minute          = 5<br>    on\_system\_errors                       = true<br>    on\_transaction\_conflict\_per\_minute     = null<br>} | <pre>object({<br>    on_conditional_check_failed_per_minute = optional(number)<br>    on_read_throttles_per_minute           = optional(number)<br>    on_write_throttles_per_minute          = optional(number)<br>    on_failed_to_replicate                 = optional(bool)<br>    on_system_errors                       = optional(bool)<br>    on_transaction_conflict_per_minute     = optional(number)<br><br>  })</pre> | <pre>{<br>  "on_conditional_check_failed_per_minute": null,<br>  "on_read_throttles_per_minute": null,<br>  "on_system_errors": true,<br>  "on_transaction_conflict_per_minute": null,<br>  "on_write_throttles_per_minute": null<br>}</pre> | no |
| <a name="input_global_secondary_indexes"></a> [global\_secondary\_indexes](#input\_global\_secondary\_indexes) | Any global secondary indexes for this table. e.g.<br>local\_secondary\_indexes = [{<br>  name "IxByOrderAndProduct"<br>  provisioned\_capacity = {<br>    read = 1<br>    write = 1<br>  }<br>  hash\_key = {<br>    name = "orderId"<br>    type = "S"<br>  }<br>  range\_key = {<br>    name = "productId"<br>    type = "S"<br>  }<br>  projection\_type = "INCLUDE" //Optional. Defaults to ALL<br>  non\_key\_attributes = ["sku", "price", "description"] //Required if projection\_type = "INCLUDE"<br>}] | <pre>set(object({<br>    name = string<br>    provisioned_capacity = optional(object({<br>      read  = number<br>      write = number<br>    }))<br>    hash_key = object({<br>      name = string<br>      type = string<br>    })<br>    range_key = optional(object({<br>      name = string<br>      type = string<br>    }))<br>    projection_type    = optional(string)<br>    non_key_attributes = optional(list(string))<br>  }))</pre> | `[]` | no |
| <a name="input_hash_key"></a> [hash\_key](#input\_hash\_key) | The hash key definition for this table. e.g.<br>hash\_key = {<br>  name = "id"<br>  type = "S"<br>} | <pre>object({<br>    name = string<br>    type = string<br>  })</pre> | n/a | yes |
| <a name="input_local_secondary_indexes"></a> [local\_secondary\_indexes](#input\_local\_secondary\_indexes) | Any local secondary indexes for this table. e.g.<br>local\_secondary\_indexes = [{<br>  name "IxByName"<br>  range\_key = {<br>    name = "name"<br>    type = "S"<br>  }<br>  projection\_type = "INCLUDE" //Optional. Defaults to ALL<br>  non\_key\_attributes = ["id", "age", "dob"] //Required if projection\_type = "INCLUDE"<br>}] | <pre>set(object({<br>    name = string<br>    range_key = optional(object({<br>      name = string<br>      type = string<br>    }))<br>    projection_type    = optional(string)<br>    non_key_attributes = optional(list(string))<br>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of this DynamoDB Table | `string` | n/a | yes |
| <a name="input_point_in_time_recovery_enabled"></a> [point\_in\_time\_recovery\_enabled](#input\_point\_in\_time\_recovery\_enabled) | Enable Point-In-Time recovery on this table | `bool` | `true` | no |
| <a name="input_provisioned_capacity"></a> [provisioned\_capacity](#input\_provisioned\_capacity) | The provisioned capacity for this table. e.g. <br>provisioned\_capacity = {<br>  read = 1<br>  write = 1<br>} | <pre>object({<br>    read  = number<br>    write = number<br>  })</pre> | `null` | no |
| <a name="input_range_key"></a> [range\_key](#input\_range\_key) | The range key definition for this table. e.g.<br>range\_key = {<br>  name = "id"<br>  type = "S"<br>} | <pre>object({<br>    name = string<br>    type = string<br>  })</pre> | `null` | no |
| <a name="input_stream_enabled"></a> [stream\_enabled](#input\_stream\_enabled) | Enable DynamoDB Streams for this table | `bool` | `false` | no |
| <a name="input_stream_view_type"></a> [stream\_view\_type](#input\_stream\_view\_type) | The stream view type for this table if streams are enabled.<br>Valid values are: NEW\_IMAGE \| OLD\_IMAGE \| NEW\_AND\_OLD\_IMAGES \| KEYS\_ONLY<br>See here for more info: https://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_StreamSpecification.html | `string` | `"NEW_AND_OLD_IMAGES"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to be added to this table | `map(string)` | `{}` | no |
| <a name="input_ttl_attribute"></a> [ttl\_attribute](#input\_ttl\_attribute) | The attribute to use as the TTL for data in this table | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key"></a> [kms\_key](#output\_kms\_key) | n/a |
| <a name="output_kms_key_alias"></a> [kms\_key\_alias](#output\_kms\_key\_alias) | n/a |
| <a name="output_table"></a> [table](#output\_table) | n/a |
