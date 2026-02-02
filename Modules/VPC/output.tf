output "vpc_id" {
  description = "VPC ID from VPC module"
  value       = module.ak_vpc.ak_vpc_id
}

output "public_subnets" {
  description = "Public subnet IDs from VPC module"
  value       = module.ak_vpc.public_subnets
}

output "private_subnets" {
  description = "Private subnet IDs from VPC module"
  value       = module.ak_vpc.private_subnets
}

output "nat_gateway_id" {
  description = "NAT Gateway ID from VPC module"
  value       = module.ak_vpc.nat_gateway_id
}
