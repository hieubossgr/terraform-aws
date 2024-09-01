# VPC
resource "aws_vpc" "custom_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "custom-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "custom_gateway" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "internet-gateway"
  }
}

# Public-1 subnet
resource "aws_subnet" "public-1" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = var.public_subnet_cidr-1
  availability_zone       = var.availability_zone_public-1a
  map_public_ip_on_launch = false
  tags = {
    Name = "public-subnet"
  }
}

# Public-2 subnet
resource "aws_subnet" "public-2" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = var.public_subnet_cidr-2
  availability_zone       = var.availability_zone_public-1b
  map_public_ip_on_launch = false
  tags = {
    Name = "public-subnet"
  }
}

# Route Table for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom_gateway.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Route Table Association for Public Subnet
resource "aws_route_table_association" "public-1" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.public.id
}

# Route Table Association for Public Subnet
resource "aws_route_table_association" "public-2" {
  subnet_id      = aws_subnet.public-2.id
  route_table_id = aws_route_table.public.id
}

# Private subnet
resource "aws_subnet" "private_ecs" {
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = var.private_ecs_subnet_cidr
  availability_zone = var.availability_zone_private
  tags = {
    Name = "private-subnet-ecs"
  }
}

# Private subnet
resource "aws_subnet" "private_cronjob" {
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = var.private_cronjob_subnet_cidr
  availability_zone = var.availability_zone_private
  tags = {
    Name = "private-subnet-cronjob"
  }
}

# Private subnet
resource "aws_subnet" "private_rds" {
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = var.private_rds_subnet_cidr
  availability_zone = var.availability_zone_private
  tags = {
    Name = "private-subnet-rds"
  }
}