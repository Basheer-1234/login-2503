# VPC
resource "aws_vpc" "login-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "lms-vpc"
  }
}

# Web Subnet
resource "aws_subnet" "lms-web-sn" {
  vpc_id     = aws_vpc.login-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "lms-web-subnet"
  }
}

# API Subnet
resource "aws_subnet" "lms-api-sn" {
  vpc_id     = aws_vpc.login-vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "lms-api-subnet"
  }
}

# DB Subnet
resource "aws_subnet" "lms-db-sn" {
  vpc_id     = aws_vpc.login-vpc.id
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "lms-database-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "lms-igw" {
  vpc_id = aws_vpc.login-vpc.id

  tags = {
    Name = "login-internet-gateway"
  }
}

# Public Route Table
resource "aws_route_table" "login-pub-rt" {
  vpc_id = aws_vpc.login-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lms-igw.id
  }

  tags = {
    Name = "login-public-rt"
  }
}