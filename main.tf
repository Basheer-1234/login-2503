# Create VPC using AWS VPC module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"

  name                 = "eks-vpc"
  cidr                 = var.vpc_cidr
  azs                  = var.availability_zones
  private_subnets      = var.private_subnets
  public_subnets       = var.public_subnets
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# Create EKS cluster using AWS EKS module
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.8.4"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  subnet_ids      = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  enable_irsa     = true

  eks_managed_node_groups = {
    default = {
      instance_types = ["t2.medium"]
      desired_size   = 2
      max_size       = 3
      min_size       = 1
      name           = "eks-node-group"
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
