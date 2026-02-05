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


