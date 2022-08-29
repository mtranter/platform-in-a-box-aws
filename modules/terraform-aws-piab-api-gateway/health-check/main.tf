variable "api_gateway_id" {
  type = string
}

variable "api_gateway_root_resource_id" {
  type = string
}

variable "health_path" {
  type = string
}

resource "aws_api_gateway_resource" "this" {
  rest_api_id = var.api_gateway_id
  parent_id   = var.api_gateway_root_resource_id
  path_part   = var.health_path
}

resource "aws_api_gateway_method" "get" {
  rest_api_id   = var.api_gateway_id
  resource_id   = aws_api_gateway_resource.this.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "mock" {
  rest_api_id = var.api_gateway_id
  resource_id = aws_api_gateway_resource.this.id
  http_method = aws_api_gateway_method.get.http_method
  type        = "MOCK"
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = var.api_gateway_id
  resource_id = aws_api_gateway_resource.this.id
  http_method = aws_api_gateway_method.get.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "response" {
  rest_api_id = var.api_gateway_id
  resource_id = aws_api_gateway_resource.this.id
  http_method = aws_api_gateway_method.get.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code

  # Transforms the backend JSON response to XML
  response_templates = {
    "application/json" = <<EOF
{
  "status": "OK"
}
EOF
  }
}
