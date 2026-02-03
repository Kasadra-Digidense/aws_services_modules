########################################################
# VPC MODULE
########################################################
module "vpc" {
  source = "git::https://github.com/Kasadra-Digidense/aws_services_modules.git//Modules/VPC?ref=main"

  vpc_cidr        = var.vpc_cidr
  vpc_tag         = var.vpc_tag
  ak_pub_subnet   = var.ak_pub_subnet
  ak_pri_subnet   = var.ak_pri_subnet
  az              = var.az
  nat_gateway_tag = var.nat_gateway_tag
}

module "pub_sg" {
  source      = "git::https://github.com/Kasadra-Digidense/aws_services_modules.git//Modules/Security_Group?ref=main"

  name        = "pub-sg"
  description = "Public Security Group"

  # ✅ USE MODULE OUTPUT
  vpc_id = module.vpc.vpc_id

ingress_rules = [
    {
      description     = "Allow SSH"
      from_port       = 22
      to_port         = 22
      protocol        = "tcp"
      cidr_blocks     = ["203.0.113.25/32"]
      security_groups = []
    },
    {
      description     = "Allow HTTP"
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
      security_groups = []
    },
    {
      description     = "Allow HTTPS"
      from_port       = 443
      to_port         = 443
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
      security_groups = []
    }
  ]

  tags = {
    Name        = "ak_pub_sg"
    Environment = "dev"
  }
}

########################################################
# KMS MODULE
########################################################
module "kms" {
  source = "git::https://github.com/Kasadra-Digidense/aws_services_modules.git//Modules/KMS/modules/kms?ref=main"

  description             = "EKS encryption key"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  aliases_name            = "alias/eks-secrets"
  role_name               = "eks-kms-user-role"
  key_policy_name         = "eks-kms-policy"
  Policy_description      = "Allows EKS to use KMS key"
  Policy_attachment       = "eks-kms-policy-attachment"
  allow                   = "Allow"
}

########################################################
# IAM MODULES
########################################################
module "eks_iam" {
  source = "git::https://github.com/Kasadra-Digidense/aws_services_modules.git//Modules/IAM/modules/iam-roles?ref=main"

  project_name = "eks"

  # Optional – only if you enable ALB IRSA
  # oidc_provider_arn = aws_iam_openid_connect_provider.eks.arn
}

########################################################
# EKS CLUSTER
########################################################
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = module.eks_iam.eks_cluster_role_arn

  vpc_config {
    subnet_ids         = module.vpc.private_subnets
    security_group_ids = [module.pub_sg.app_sg_id]
  }

  # Enable encryption for secrets
  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = module.kms.kms_key_arn  # Use the output from your KMS module
    }
  }

  tags = var.tags
}



########################################################
# EKS NODE GROUP
########################################################
resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = var.node_group_name
  node_role_arn   = module.eks_iam.eks_node_role_arn
  subnet_ids      = module.vpc.private_subnets

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }

  tags = var.tags
}
