

module "service" {
  source              = "./../../../modules/service"
  service_name        = "PricingService"
  source_folder       = "${path.module}/../package/dist"
  dependencies_folder = "${path.module}/../package/dependencies"
  commit_hash         = var.commit_hash
  sns_topics = [{
    name    = "UserEvents"
    is_fifo = true
  }]
  api_handler = {
    api_openapi_spec = "${path.module}/../package/openapi.json"
    handler          = "api.handler"
  }
  dynamodb_table = {
    hash_key = {
      name = "hash"
      type = "S"
    }
    range_key = {
      name = "range"
      type = "S"
    }
    stream_enabled = true
    table_name     = "PricingService"
  }
}

output "base_url" {
  value = module.service.base_url
}
