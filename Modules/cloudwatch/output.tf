output "log_group_eks_name" {
  value = aws_cloudwatch_log_group.eks.name
}

output "log_group_app_name" {
  value = aws_cloudwatch_log_group.app.name
}

output "sns_topic_arn" {
  value = aws_sns_topic.alerts.arn
}
