variable "region" {
  default = "us-east-1"
}

variable "bucket_name" {
  description = "Terraform state bucket name"
  default = "bucket-009876"
}

variable "lock_table_name" {
  description = "DynamoDB lock table name"
  default = "stable-lock"
}
