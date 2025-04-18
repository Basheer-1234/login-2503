# Variables

# AWS Access Key ID
variable aws_access_key {
  description = "Please Input AWS Access Key ID"
}

# AWS Secret Key ID
variable aws_secret_key {
  description = "Please Input AWS Secret Key ID"
}

# VPC CIDR
variable vpc_cidr {
  description = "Please Input VPC CIDR"
}

# VPC Tenancy
variable vpc_tenancy {
  default = "default"
}

# VPC Name
variable vpc_name {
  description = "Please Input VPC Name"
}

# VPC Public Subnets
variable public_subnets_cidrs {
  description = "Please Input Subnet Details"
  type = map(string)
  default = {
    frontend = "10.0.0.0/24"
    backend = "10.0.1.0/24"
    loadbalancer = "10.0.2.0/24"
  }
}

# VPC Public Subnets
variable private_subnets_cidrs {
  description = "Please Input Subnet Details"
  type = map(string)
  default = {
    database = "10.0.3.0/24"
    cache = "10.0.4.0/24"
  }
}