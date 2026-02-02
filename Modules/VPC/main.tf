###########################################################
# Call VPC Module
###########################################################
module "ak_vpc" {
  source = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  az = ["us-east-1a", "us-east-1b"]
  ak_pub_subnet = ["10.0.1.0/24", "10.0.2.0/24"]
  ak_pri_subnet = ["10.0.101.0/24", "10.0.102.0/24"]

  vpc_tag = {
    Name        = "ak-vpc"
    Environment = "dev"
  }

  nat_gateway_tag = {
    Name        = "ak-nat-gw"
    Environment = "dev"
  }
}


###########################################################
# Call Security Group Module
###########################################################
module "pub_sg" {
  source      = "git::https://github.com/Kasadra-Digidense/aws_services_modules.git//Modules/Security_Group?ref=main"
  name        = "pub-sg"
  description = "Public Security Group"
  vpc_id      = module.ak_vpc.ak_vpc_id   # output from VPC module

  ingress_rules = [
    {
      description     = "Allow SSH from Dev IP only"
      from_port       = 22
      to_port         = 22
      protocol        = "tcp"
      cidr_blocks     = ["203.0.113.25/32"]  # <-- valid CIDR
      security_groups = []
    },
    {
      description     = "Allow HTTP from internet"
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
      security_groups = []
    },
    {
      description     = "Allow HTTPS from internet"
      from_port       = 443
      to_port         = 443
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
      security_groups = []
    }
  ]


  tags = {
    Environment = "dev"
    Name        = "ak_pub_sg"
  }
}

