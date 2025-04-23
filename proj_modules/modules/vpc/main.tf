# VPC
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnet_cidr
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${var.vpc_name}-public-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}-internet-gateway"
  }
}

# Public Route Table
resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

# Public Route Table - Public SNS ASC
resource "aws_route_table_association" "public-asc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.pub-rt.id
}

# Frontend Security Group
resource "aws_security_group" "web-sg" {
  name        = "frontend-sg"
  description = "Allow Frontend Traffic"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}-fe-sg"
  }
}

# Web Security Group - SSH
resource "aws_vpc_security_group_ingress_rule" "web-sg-ssh" {
  security_group_id = aws_security_group.web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Web Security Group - HTTP
resource "aws_vpc_security_group_ingress_rule" "web-sg-http" {
  security_group_id = aws_security_group.web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Web Security Group - Outbound All
resource "aws_vpc_security_group_egress_rule" "web-sg-outbound" {
  security_group_id = aws_security_group.web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  ip_protocol       = "tcp"
  to_port           = 65535
}