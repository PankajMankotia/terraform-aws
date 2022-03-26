resource "aws_s3_bucket" "b" {
  bucket = "s3-dtedemo-storage"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "S3-Remote-backend"
    Environment = "Dev"
    Component   = "dte"
  }

  lifecycle_rule {
    enabled                                = true
    abort_incomplete_multipart_upload_days = 7

    transition {
      days          = 10
      storage_class = "GLACIER"
    }

    transition {
      days          = 365
      storage_class = "DEEP_ARCHIVE"
    }

    expiration {
      days = 3560
    }

    noncurrent_version_transition {
      days          = 20
      storage_class = "GLACIER"
    }

    noncurrent_version_transition {
      days          = 750
      storage_class = "DEEP_ARCHIVE"
    }

    noncurrent_version_expiration {
      days = 7500
    }
  }
}