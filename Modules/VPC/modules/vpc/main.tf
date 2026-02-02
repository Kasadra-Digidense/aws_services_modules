###########################################################
# Create VPC
###########################################################
resource "aws_vpc" "ak_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = var.vpc_tag
}

###########################################################
# Create Public Subnets
###########################################################
resource "aws_subnet" "pub_subnet" {
  count                   = length(var.ak_pub_subnet)
  vpc_id                  = aws_vpc.ak_vpc.id
  cidr_block              = var.ak_pub_subnet[count.index]
  availability_zone       = var.az[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "ak-pub-subnet-${count.index + 1}"
  }
}

###########################################################
# Create Private Subnets
###########################################################
resource "aws_subnet" "pri_subnet" {
  count             = length(var.ak_pri_subnet)
  vpc_id            = aws_vpc.ak_vpc.id
  cidr_block        = var.ak_pri_subnet[count.index]
  availability_zone = var.az[count.index]

  tags = {
    Name = "ak-pri-subnet-${count.index + 1}"
  }
}

###########################################################
# Create Internet Gateway
###########################################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ak_vpc.id

  tags = {
    Name = "ak-igw"
  }
}

###########################################################
# Create Public Route Table
###########################################################
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.ak_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "ak-public-rt"
  }
}

###########################################################
# Associate Public Route Table
###########################################################
resource "aws_route_table_association" "pub_rt_assoc" {
  count          = length(var.ak_pub_subnet)
  route_table_id = aws_route_table.pub_rt.id
  subnet_id      = aws_subnet.pub_subnet[count.index].id
}

###########################################################
# Create Elastic IP for NAT Gateway
###########################################################
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

###########################################################
# Create NAT Gateway
###########################################################
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.pub_subnet[0].id

  depends_on = [aws_internet_gateway.igw]

  tags = var.nat_gateway_tag
}

###########################################################
# Create Private Route Table
###########################################################
resource "aws_route_table" "pri_rt" {
  vpc_id = aws_vpc.ak_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "ak-private-rt"
  }
}

###########################################################
# Associate Private Route Table
###########################################################
resource "aws_route_table_association" "pri_rt_assoc" {
  count          = length(var.ak_pri_subnet)
  route_table_id = aws_route_table.pri_rt.id
  subnet_id      = aws_subnet.pri_subnet[count.index].id
}

