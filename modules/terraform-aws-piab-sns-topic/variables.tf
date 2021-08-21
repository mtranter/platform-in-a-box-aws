variable "topic_name" {
  type        = string
  description = "The name of this topic. If it is a FIFO topic, '.fifo' will be appended to the name"
}

variable "is_fifo" {
  type        = bool
  description = "Create a FIFO queue"
}

variable "content_based_deduplication" {
  type        = bool
  default     = null
  description = "Use Content based deduplication for a FIFO queue"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Any tags for this queue"
}

variable "topic_policy_sources" {
  type        = list(string)
  default     = null
  description = <<EOF
An IAM policy that will be merged with the Topic policy
See here: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#source_policy_documents
EOF
}

variable "key_policy_sources" {
  default     = null
  type        = list(string)
  description = <<EOF
An IAM policy that will be merged with the KMS Key policy for this topic
See here: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#source_policy_documents
EOF
}