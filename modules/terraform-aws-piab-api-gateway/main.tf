resource "aws_api_gateway_rest_api" "api" {
  name = var.api_name
  body = var.openapi_spec
}

module "healthcheck" {
  count                        = var.healthcheck_config.enabled && var.openapi_spec == null ? 1 : 0
  source                       = "./health-check"
  api_gateway_id               = aws_api_gateway_rest_api.api.id
  api_gateway_root_resource_id = aws_api_gateway_rest_api.api.root_resource_id
  health_path                  = var.healthcheck_config.path
}
