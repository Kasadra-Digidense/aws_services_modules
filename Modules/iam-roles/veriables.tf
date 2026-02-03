variable "project_name" {
  description = "Project name"
  type        = string
  default     = "react"
}

variable "oidc_provider_arn" {
  description = "OIDC provider ARN for IRSA (ALB Controller, etc.)"
  type        = string
  default     = null
}

variable "github_repo" {
  description = "GitHub repo in org/repo format"
  type        = string
  default     = "ORG/REPO"
}
