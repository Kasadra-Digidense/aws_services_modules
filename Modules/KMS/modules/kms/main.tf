# Creates an AWS KMS key
resource "aws_kms_key" "my_kms_key" {
  description             = var.description
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation
}

# Creates an AWS KMS alias name
resource "aws_kms_alias" "my_alias" {
  name          = var.aliases_name
  target_key_id = aws_kms_key.my_kms_key.arn
}

# Grants permissions to a specific principal
resource "aws_kms_grant" "my_kms_key_grant" {
  key_id            = aws_kms_key.my_kms_key.key_id
  grantee_principal = aws_iam_role.kms_key_user_role.arn
  operations        = ["Encrypt", "Decrypt", "GenerateDataKey"]
}

# Creates an IAM role with a policy allowing it to assume a role
resource "aws_iam_role" "kms_key_user_role" {
  name               = var.role_name
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "sns.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })
}

# IAM policy document allowing specific actions on the KMS key and S3 full access
data "aws_iam_policy_document" "kms_key_policy" {
  statement {
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:GenerateDataKey",
      "kms:DescribeKey",
      "s3:*"  // Allows all actions on S3
    ]
    resources = [
      aws_kms_key.my_kms_key.arn,
      "arn:aws:s3:::*"  // Specifies all S3 resources
    ]
    effect    = var.allow
  }
}

# Creates an IAM policy using the policy document
resource "aws_iam_policy" "kms_key_policy" {
  name        = var.key_policy_name
  description = var.Policy_description
  policy      = data.aws_iam_policy_document.kms_key_policy.json
}

# Attaches the IAM policy to the IAM role
resource "aws_iam_policy_attachment" "kms_key_access_attachment" {
  name       = var.Policy_attachment
  roles      = [aws_iam_role.kms_key_user_role.name]
  policy_arn = aws_iam_policy.kms_key_policy.arn
}