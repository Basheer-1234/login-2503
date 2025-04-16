# VPC
resource "aws_vpc" "ecomm-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "ecomm-vpc"
  }
}

# Web Subnet
resource "aws_subnet" "ecomm-web-sn" {
  vpc_id     = aws_vpc.ecomm-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "ecomm-web-subnet"
  }
}

# API Subnet
resource "aws_subnet" "ecomm-api-sn" {
  vpc_id     = aws_vpc.ecomm-vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "ecomm-api-subnet"
  }
}

# DB Subnet
resource "aws_subnet" "ecomm-db-sn" {
  vpc_id     = aws_vpc.ecomm-vpc.id
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "ecomm-database-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "ecomm-igw" {
  vpc_id = aws_vpc.ecomm-vpc.id

  tags = {
    Name = "ecomm-internet-gateway"
  }
}

# Public Route Table
resource "aws_route_table" "ecomm-pub-rt" {
  vpc_id = aws_vpc.ecomm-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecomm-igw.id
  }

  tags = {
    Name = "ecomm-public-rt"
  }
}


# Public Route Table - Web SN ASC
resource "aws_route_table_association" "ecomm-web-sn-asc" {
  subnet_id      = aws_subnet.ecomm-web-sn.id
  route_table_id = aws_route_table.ecomm-pub-rt.id
}

# Public Route Table - API SN ASC
resource "aws_route_table_association" "ecomm-api-sn-asc" {
  subnet_id      = aws_subnet.ecomm-api-sn.id
  route_table_id = aws_route_table.ecomm-pub-rt.id
}

# Private Route Table
resource "aws_route_table" "ecomm-pvt-rt" {
  vpc_id = aws_vpc.ecomm-vpc.id

  tags = {
    Name = "ecomm-private-rt"
  }
}

# Private Route Table - DB SN ASC
resource "aws_route_table_association" "ecomm-db-sn-asc" {
  subnet_id      = aws_subnet.ecomm-db-sn.id
  route_table_id = aws_route_table.ecomm-pvt-rt.id
}

# Web NACL
resource "aws_network_acl" "ecomm-web-nacl" {
  vpc_id = aws_vpc.ecomm-vpc.id

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
    Name = "ecomm-web-nacl"
  }
}

# Web NACL Association
resource "aws_network_acl_association" "ecomm-web-nacl-asc" {
  network_acl_id = aws_network_acl.ecomm-web-nacl.id
  subnet_id      = aws_subnet.ecomm-web-sn.id
}

# API NACL
resource "aws_network_acl" "ecomm-api-nacl" {
  vpc_id = aws_vpc.ecomm-vpc.id

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
    Name = "ecomm-api-nacl"
  }
}

# API NACL Association
resource "aws_network_acl_association" "ecomm-api-nacl-asc" {
  network_acl_id = aws_network_acl.ecomm-api-nacl.id
  subnet_id      = aws_subnet.ecomm-api-sn.id
}

# DB NACL
resource "aws_network_acl" "ecomm-db-nacl" {
  vpc_id = aws_vpc.ecomm-vpc.id

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
    Name = "ecomm-db-nacl"
  }
}

# DB NACL Association
resource "aws_network_acl_association" "ecomm-db-nacl-asc" {
  network_acl_id = aws_network_acl.ecomm-db-nacl.id
  subnet_id      = aws_subnet.ecomm-db-sn.id
}

# Web Security Group
resource "aws_security_group" "ecomm-web-sg" {
  name        = "ecomm-web"
  description = "Allow WebServer Traffic"
  vpc_id      = aws_vpc.ecomm-vpc.id

  tags = {
    Name = "ecomm-web"
  }
}

# Web Security Group - SSH
resource "aws_vpc_security_group_ingress_rule" "ecomm-web-sg-ssh" {
  security_group_id = aws_security_group.ecomm-web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Web Security Group - HTTP
resource "aws_vpc_security_group_ingress_rule" "ecomm-web-sg-http" {
  security_group_id = aws_security_group.ecomm-web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Web Security Group - HTTPS
resource "aws_vpc_security_group_ingress_rule" "ecomm-web-sg-https" {
  security_group_id = aws_security_group.ecomm-web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

# Web Security Group - Outbound All
resource "aws_vpc_security_group_egress_rule" "ecomm-web-sg-outbound" {
  security_group_id = aws_security_group.ecomm-web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  ip_protocol       = "tcp"
  to_port           = 65535
}

# API Security Group
resource "aws_security_group" "ecomm-api-sg" {
  name        = "ecomm-api"
  description = "Allow API Server Traffic"
  vpc_id      = aws_vpc.ecomm-vpc.id

  tags = {
    Name = "ecomm-api"
  }
}

# API Security Group - SSH
resource "aws_vpc_security_group_ingress_rule" "ecomm-api-sg-ssh" {
  security_group_id = aws_security_group.ecomm-api-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# API Security Group - HTTP
resource "aws_vpc_security_group_ingress_rule" "ecomm-api-sg-http" {
  security_group_id = aws_security_group.ecomm-api-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3000
  ip_protocol       = "tcp"
  to_port           = 3000
}

# API Security Group - Outbound All
resource "aws_vpc_security_group_egress_rule" "ecomm-api-sg-outbound" {
  security_group_id = aws_security_group.ecomm-api-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  ip_protocol       = "tcp"
  to_port           = 65535
}

# DB Security Group
resource "aws_security_group" "ecomm-db-sg" {
  name        = "ecomm-db"
  description = "Allow DB Server Traffic"
  vpc_id      = aws_vpc.ecomm-vpc.id

  tags = {
    Name = "ecomm-db"
  }
}

# DB Security Group - SSH
resource "aws_vpc_security_group_ingress_rule" "ecomm-db-sg-ssh" {
  security_group_id = aws_security_group.ecomm-db-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# DB Security Group - MYSQL
resource "aws_vpc_security_group_ingress_rule" "ecomm-db-sg-mysql" {
  security_group_id = aws_security_group.ecomm-db-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
}

# DB Security Group - Outbound All
resource "aws_vpc_security_group_egress_rule" "ecomm-db-sg-outbound" {
  security_group_id = aws_security_group.ecomm-db-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  ip_protocol       = "tcp"
  to_port           = 65535
}

# Web Server Instance
resource "aws_instance" "ecomm-web-server" {
  ami           = "ami-0c3b809fcf2445b6a"
  instance_type = "t2.micro"
  key_name      = "2501"
  subnet_id     = aws_subnet.ecomm-web-sn.id
  vpc_security_group_ids = [aws_security_group.ecomm-web-sg.id]
  user_data     = file("script.sh")

  tags = {
    Name = "ecomm-web-server"
  }
}