
output "queue_policy" {
  value       = data.aws_iam_policy_document.queue_policy.json
  description = "The value to use for the queue_policy_json argument when creating an SQS queue with PIAB"
}

output "kms_policy" {
  value       = data.aws_iam_policy_document.allow_sns_kms_queue_access.json
  description = "The value to use for the kms_policy_source_json argument when creating an SQS queue with PIAB"
}