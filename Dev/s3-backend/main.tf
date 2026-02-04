provider "aws" {
  region = var.region
}

############################
# KMS Key for Terraform State
############################
resource "aws_kms_key" "tf_state" {
  description             = "KMS key for Terraform state"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_alias" "tf_state" {
  name          = "alias/terraform-state"
  target_key_id = aws_kms_key.tf_state.key_id
}

############################
# S3 Bucket for Terraform State
############################
resource "aws_s3_bucket" "tf_state" {
  bucket = var.bucket_name
}

# Versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.tf_state.arn
    }
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "block" {
  bucket                  = aws_s3_bucket.tf_state.id
  block_public_acls        = true
  block_public_policy      = true
  ignore_public_acls       = true
  restrict_public_buckets = true
}

############################
# DynamoDB for State Locking
############################
resource "aws_dynamodb_table" "tf_lock" {
  name         = var.lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
