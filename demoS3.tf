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
}
