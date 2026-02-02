variable "project_name" {
  type        = string
  description = "Project name"
}

variable "oidc_provider_arn" {
  type        = string
  description = "OIDC provider ARN for EKS"
  default     = null
}

variable "region" {
  type        = string
  default     = "us-east-1"
}

