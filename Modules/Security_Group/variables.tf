variable "name" {
  description = "Security group name"
  type        = string
  default     = "simple"
}

variable "description" {
  description = "Security group description"
  type        = string
  default     = "Security group description"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = "vpc-05528a3c7151b0996"
}

variable "ingress_rules" {
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string), [])
    security_groups = optional(list(string), [])
  }))

  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules :
      !(
        r.from_port == 22 &&
        contains(r.cidr_blocks, "0.0.0.0/0")
      )
    ])
    error_message = "Public SSH (22) is not allowed"
  }
}



variable "egress_rules" {
  description = "List of egress rules"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "app_port" {
  description = "Application port"
  type        = number
  default     = 80
}