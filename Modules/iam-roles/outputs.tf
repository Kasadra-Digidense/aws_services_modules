output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_role_arn" {
  value = aws_iam_role.eks_node_role.arn
}

output "alb_ingress_role_arn" {
  value       = try(aws_iam_role.alb_ingress_role[0].arn, null)
  description = "IRSA role for ALB Ingress Controller"
}
