locals {
  lifecycle_transitions = { for o in var.lifecycle_transitions : o.id => o }
}

terraform {
  experiments = [module_variable_optional_attrs]
}

#tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket
}

#tfsec:ignore:aws-s3-enable-versioning
resource "aws_s3_bucket_versioning" "versioning_example" {

  bucket = aws_s3_bucket.bucket.id


  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.bucket
  acl    = "private"
}

resource "aws_s3_bucket_logging" "logging" {
  count  = var.access_logs == null ? 0 : 1
  bucket = aws_s3_bucket.bucket

  target_bucket = var.access_logs.target_bucket
  target_prefix = coalesce(var.access_logs.target_prefix, "${var.bucket}/")

}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.bucket.id

  dynamic "rule" {
    for_each = local.lifecycle_transitions
    iterator = each
    content {
      status = "Enabled"
      id     = each.value.id
      prefix = each.value.prefix
      dynamic "abort_incomplete_multipart_upload" {
        for_each = each.value.abort_incomplete_multipart_upload_days == null ? [] : [1]
        iterator = each
        content {
          days_after_initiation = each.value.abort_incomplete_multipart_upload_days
        }
      }
      dynamic "expiration" {
        for_each = each.value.expiration == null ? [] : [1]
        content {
          date                         = each.value.expiration.date
          days                         = each.value.expiration.days
          expired_object_delete_marker = each.value.expiration.expired_object_delete_marker
        }
      }

      dynamic "transition" {
        for_each = each.value.transition == null ? [] : [1]
        content {
          date          = each.value.transition.date
          days          = each.value.transition.days
          storage_class = each.value.transition.storage_class
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = each.value.noncurrent_version_expiration == null ? [] : [1]
        content {
          noncurrent_days = each.value.noncurrent_version_expiration.days
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = each.value.noncurrent_version_transition == null ? [] : [1]
        content {
          noncurrent_days = each.value.noncurrent_version_transition.days
          storage_class   = each.value.noncurrent_version_transition.storage_class
        }
      }
    }
  }
}
