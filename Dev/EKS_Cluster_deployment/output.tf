output "eks_cluster_name" {
  value = aws_eks_cluster.main.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "eks_cluster_ca" {
  value = aws_eks_cluster.main.certificate_authority[0].data
}

output "node_group_name" {
  value = aws_eks_node_group.default.node_group_name
}

###########################################################
# VPC Outputs (from module)
###########################################################
###########################################################
# VPC Outputs
###########################################################
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnets
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = module.vpc.nat_gateway_id
}

output "alb_security_group_id" {
  description = "ALB Security Group ID"
  value       = module.pub_sg.alb_sg_id
}

output "app_security_group_id" {
  description = "Application / EKS Security Group ID"
  value       = module.pub_sg.app_sg_id
}

###########################################################
# KMS Outputs
###########################################################

output "kms_key_id" {
  description = "KMS Key ID for EKS Encryption"
  value       = module.kms.kms_key_id
}

output "kms_key_arn" {
  description = "KMS Key ARN for EKS Encryption"
  value       = module.kms.kms_key_arn
}
