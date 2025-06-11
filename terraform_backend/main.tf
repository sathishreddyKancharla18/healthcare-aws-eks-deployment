# Create a secure S3 bucket
resource "aws_s3_bucket" "secure_bucket" {
  bucket = "my-secure-bucket-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"

  force_destroy = false

  tags = {
    Name        = "Secure S3 Bucket"
    Environment = "Production"
  }
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "secure_block" {
  bucket                  = aws_s3_bucket.secure_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.secure_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enable access logging to a separate bucket (recommended)
resource "aws_s3_bucket" "log_bucket" {
  bucket = "my-secure-bucket-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}" # Must be globally unique
}

resource "aws_s3_bucket_logging" "logging" {
  bucket = aws_s3_bucket.secure_bucket.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}

# Create a secure DynamoDB table
resource "aws_dynamodb_table" "secure_table" {
  name         = "secure-dynamodb-table"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
    # If using a custom KMS key, add `kms_key_arn = "<KMS_KEY_ARN>"`
  }

  tags = {
    Name        = "Secure DynamoDB Table"
    Environment = "Production"
  }
}
