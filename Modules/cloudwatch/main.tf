############################
# SNS Topic for Alerts
############################
resource "aws_sns_topic" "alerts" {
  name = "${var.project_name}-cw-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}

############################
# CloudWatch Log Groups
############################
resource "aws_cloudwatch_log_group" "eks" {
  name              = "/aws/eks/${var.project_name}/cluster"
  retention_in_days = var.retention_in_days
}

resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/${var.project_name}/application"
  retention_in_days = var.retention_in_days
}

############################
# IAM Role for CloudWatch Agent
############################
resource "aws_iam_role" "cloudwatch_role" {
  name = "${var.project_name}-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "cloudwatch_policy" {
  name   = "${var.project_name}-cloudwatch-policy"
  policy = file("${path.module}/cloudwatch-policy.json")
}

resource "aws_iam_role_policy_attachment" "cw_attach" {
  role       = aws_iam_role.cloudwatch_role.name
  policy_arn = aws_iam_policy.cloudwatch_policy.arn
}

############################
# CPU Alarm (EKS Nodes)
############################
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.project_name}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  alarm_actions = [aws_sns_topic.alerts.arn]
}
