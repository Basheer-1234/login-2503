# VPC
resource "aws_vpc" "login-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.tenancy

  tags = {
    Name = var.vpc_name
  }
}

# Public Subnets
resource "aws_subnet" "public_subnets" {
  vpc_id     = aws_vpc.login-vpc.id
  for_each   = var.public_subnets_cidrs
  cidr_block = each.value
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${var.vpc_name}-${each.key}-subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnets" {
  vpc_id     = aws_vpc.login-vpc.id
  for_each   = var.private_subnets_cidrs
  cidr_block = each.value
  map_public_ip_on_launch = "false"

  tags = {
    Name = "${var.vpc_name}-${each.key}-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "login-igw" {
  vpc_id = aws_vpc.login-vpc.id

  tags = {
    Name = "${var.vpc_name}-internet-gateway"
  }
}

# Public Route Table
resource "aws_route_table" "login-pub-rt" {
  vpc_id = aws_vpc.login-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.login-igw.id
  }

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

# Public Route Table - Public SNS ASC
resource "aws_route_table_association" "login-public-asc" {
  for_each       = var.public_subnets_cidrs  
  subnet_id      = aws_subnet.public_subnets[each.key].id
  route_table_id = aws_route_table.login-pub-rt.id
}


# Private Route Table
resource "aws_route_table" "login-pvt-rt" {
  vpc_id = aws_vpc.login-vpc.id

  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}

# Private Route Table - Private SNS ASC
resource "aws_route_table_association" "login-private-asc" {
  for_each       = var.private_subnets_cidrs
  subnet_id      = aws_subnet.private_subnets[each.key].id
  route_table_id = aws_route_table.login-pvt-rt.id
}

# Public NACL
resource "aws_network_acl" "login-public-nacl" {
  vpc_id = aws_vpc.login-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "${var.vpc_name}-public-nacl"
  }
}

# Public NACL Association
resource "aws_network_acl_association" "login-public-nacl-asc" {
  network_acl_id = aws_network_acl.login-public-nacl.id
  subnet_id      = aws_subnet.public_subnets[each.key].id
}


# Private NACL
resource "aws_network_acl" "login-private-nacl" {
  vpc_id = aws_vpc.login-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "${var.vpc_name}-private-nacl"
  }
}

# Public NACL Association
resource "aws_network_acl_association" "login-private-nacl-asc" {
  network_acl_id = aws_network_acl.login-private-nacl.id
  subnet_id      = aws_subnet.private_subnets[each.key].id
}

# Frontend Security Group
resource "aws_security_group" "login-fe-sg" {
  name        = "login-frontend"
  description = "Allow Frontend Traffic"
  vpc_id      = aws_vpc.login-vpc.id

  tags = {
    Name = "${var.vpc_name}-fe-sg"
  }
}

# Frontend Security Group Rules
resource "aws_vpc_security_group_ingress_rule" "login-web-sg-ssh" {
  security_group_id = aws_security_group.login-fe-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}