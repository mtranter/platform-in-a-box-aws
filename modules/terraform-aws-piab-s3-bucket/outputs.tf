output "bucket" {
  value = aws_s3_bucket.bucket
}

output "kms_key" {
  value = var.use_custom_kms ? aws_kms_key.key[0] : null
}

output "kms_key_alias" {
  value = var.use_custom_kms ? aws_kms_alias.alias : null
}