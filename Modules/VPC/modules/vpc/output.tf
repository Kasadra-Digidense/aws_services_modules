###########################################################
# VPC ID
###########################################################
output "ak_vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.ak_vpc.id
}

###########################################################
# Public Subnets
###########################################################
output "public_subnets" {
  description = "List of public subnet IDs"
  value       = aws_subnet.pub_subnet[*].id
}

###########################################################
# Private Subnets
###########################################################
output "private_subnets" {
  description = "List of private subnet IDs"
  value       = aws_subnet.pri_subnet[*].id
}

###########################################################
# Internet Gateway
###########################################################
output "igw_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.igw.id
}

###########################################################
# Public Route Table
###########################################################
output "pub_route_table_id" {
  description = "Public Route Table ID"
  value       = aws_route_table.pub_rt.id
}

###########################################################
# Private Route Table
###########################################################
output "pri_route_table_id" {
  description = "Private Route Table ID"
  value       = aws_route_table.pri_rt.id
}

###########################################################
# NAT Gateway
###########################################################
output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.nat_gw.id
}
