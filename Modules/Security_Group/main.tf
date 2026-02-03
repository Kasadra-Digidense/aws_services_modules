# ALB Security Group (Internet → ALB)

module "alb_sg" {
  source = "./modules/security-group"

  name        = "alb-sg-new"
  description = "ALB security group"
  vpc_id      = var.vpc_id

  ingress_rules = [
    {
      description     = "Allow HTTPS from internet"
      from_port       = 443
      to_port         = 443
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
      security_groups = []
    }
  ]

  egress_rules = [
    {
      description     = "Forward traffic to app SG"
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      cidr_blocks     = []
      security_groups = [module.app_sg.security_group_id]
    }
  ]
}


# App Security Group (ALB → App)

module "app_sg" {
  source = "./modules/security-group"

  name        = "app-sg"
  description = "Application security group"
  vpc_id      = var.vpc_id

  ingress_rules = [
    {
      description     = "Allow traffic from ALB SG only"
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      cidr_blocks     = []
      security_groups = [module.alb_sg.security_group_id]
    }
  ]

  egress_rules = [
    {
      description     = "Allow HTTPS outbound"
      from_port       = 443
      to_port         = 443
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
      security_groups = []
    }
  ]
}


