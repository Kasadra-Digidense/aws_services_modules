variable "description" {
  type        = string
  description = "The description for the KMS key"
  default     = "Kms_keys"
}

variable "deletion_window_in_days" {
  type        = number
  description = "The deletion window in days"
  default     = 7
}

variable "enable_key_rotation" {
  type        = bool
  description = "Enable key rotation"
  default     = true
}

variable "aliases_name" {
  type        = string
  description = "this is for kms key name creation"
  default     = "alias/Flash_stream_keys"
}

variable "role_name" {
  type        = string
  description = "The description for the KMS key role name"
  default     = "sns_role"
}

variable "allow" {
  type        = string
  description = "The description for the KMS key allow permission"
  default     = "Allow"
}

variable "key_policy_name" {
  type        = string
  description = "The description for the KMS key policy name"
  default     = "KMS_Key_Policy"
}

variable "Policy_description" {
  type        = string
  description = "The description for the KMS key policy description"
  default     = "Policy to allow access to KMS keys"
}

variable "Policy_attachment" {
  type        = string
  description = "The description for the KMS key policy access attachment"
  default     = "KMS_Access_Attachment"
}