output "bucket_name" {
  value = aws_s3_bucket.tf_state.bucket
}

output "dynamodb_table" {
  value = aws_dynamodb_table.tf_lock.name
}

output "kms_key_arn" {
  value = aws_kms_key.tf_state.arn
}
