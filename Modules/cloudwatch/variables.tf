variable "project_name" {
  description = "Project name"
  type        = string
}

variable "retention_in_days" {
  description = "Log retention period"
  type        = number
  default     = 14
}

variable "alarm_email" {
  description = "Email for CloudWatch alarms"
  type        = string
}
