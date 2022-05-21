variable "service_name" {
  type = string
}

variable "source_folder" {
  type = string
}

variable "dependencies_folder" {
  type = string
}

variable "api_handler" {
  type = object({
    handler          = string
    api_openapi_spec = string
  })
  default = null
}

variable "queue_handlers" {
  type = set(object({
    name    = string
    handler = string
    queue_config = object({
      name            = string
      is_fifo         = bool
      sns_source_name = optional(string)
    })
  }))
  default = []
}

variable "dynamodb_table" {
  type = object({
    table_name = string
    hash_key = object({
      name = string
      type = string
    })
    range_key = optional(object({
      name = string
      type = string
    }))
    stream_enabled = optional(bool)
    lsis = optional(set(object({
      name = string
      range_key = optional(object({
        name = string
        type = string
      }))
    })))
    gsis = optional(set(object({
      name = string
      provisioned_capacity = optional(object({
        read  = number
        write = number
      }))
      hash_key = object({
        name = string
        type = string
      })
      range_key = optional(object({
        name = string
        type = string
      }))
    })))
  })
  default = null
}

variable "sns_topics" {
  type = set(object({
    name    = string
    is_fifo = bool
  }))
  default = []
}

variable "env_vars" {
  type    = map(string)
  default = {}
}

variable "commit_hash" {
  type = string
}
