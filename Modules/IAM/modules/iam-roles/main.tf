resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.project_name}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}



resource "aws_iam_role" "eks_node_role" {
  name = "${var.project_name}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "node_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ])

  role       = aws_iam_role.eks_node_role.name
  policy_arn = each.value
}


data "aws_iam_policy_document" "alb_assume_role" {
  count = var.oidc_provider_arn == null ? 0 : 1

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "sts.amazonaws.com"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "alb_ingress_role" {
  count = var.oidc_provider_arn == null ? 0 : 1
  name  = "${var.project_name}-alb-ingress-role"

  assume_role_policy = data.aws_iam_policy_document.alb_assume_role[0].json
}

resource "aws_iam_policy" "alb_ingress_policy" {
  name   = "${var.project_name}-alb-ingress-policy"
  policy = file("${path.module}/policies/alb-ingress.json")
}

resource "aws_iam_role_policy_attachment" "alb_policy_attach" {
  count      = var.oidc_provider_arn == null ? 0 : 1
  role       = aws_iam_role.alb_ingress_role[0].name
  policy_arn = aws_iam_policy.alb_ingress_policy.arn
}


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


resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  role       = aws_iam_role.cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
