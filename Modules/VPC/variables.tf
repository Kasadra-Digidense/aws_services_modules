###########################################################
# VPC Variables
###########################################################
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "192.168.0.0/24"
}

variable "vpc_tag" {
  description = "Tags for VPC"
  type = object({
    Name        = string
    Environment = string
  })
  default = {
    Name        = "ak-vpc"
    Environment = "Dev"
  }
}

###########################################################
# Subnet Variables
###########################################################
variable "ak_pub_subnet" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["192.168.0.0/26", "192.168.0.64/26"]
}

variable "ak_pri_subnet" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = ["192.168.0.128/26", "192.168.0.192/26"]
}

variable "az" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

###########################################################
# NAT Gateway Tags
###########################################################
variable "nat_gateway_tag" {
  description = "Tags for NAT Gateway"
  type = object({
    Name = string
  })
  default = {
    Name = "ak-nat-gateway"
  }
}

###########################################################
# Security Group
###########################################################

variable "sg_port_pub" {
  description = "Port traffic enable"
  type        = list(number)
  default     = [22, 80, 443, 5432]
}