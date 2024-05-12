// Configure Terraform providers
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
// Define AWS provider configuration
provider "aws" {
  region = "us-east-1"   //provide your Region here  
}
// Include modules for specific configurations

module "vpc" {
  //source = "github.com/lily4499/terraform-aws-eks-cvpc.git/my_vpc"
  source = "lily4499/eks-cvpc/aws//my_vpc"
  version = ">= 1.0.0, < 2.0.0"

  vpc_id         = "aws_vpc.eks_vpc.id"
  vpc_cidr       = "10.0.0.0/16"
  dns_hostnames  = true
  dns_support    = true
  pub_one_cidr   = "10.0.1.0/24"
  pub_two_cidr   = "10.0.2.0/24"
  priv_one_cidr  = "10.0.3.0/24"
  priv_two_cidr  = "10.0.4.0/24"
}

module "eks" {
  //source = "github.com/lily4499/terraform-aws-eks-cvpc.git/my_eks"
  source = "lily4499/eks-cvpc/aws//my_eks"
  version = ">= 1.0.0, < 2.0.0"

  vpc_id         = "aws_vpc.eks_vpc.id"
  vpc_cidr       = "10.0.0.0/16"
  dns_hostnames  = true
  dns_support    = true
  pub_one_cidr   = "10.0.1.0/24"
  pub_two_cidr   = "10.0.2.0/24"
  priv_one_cidr  = "10.0.3.0/24"
  priv_two_cidr  = "10.0.4.0/24"
  cluster_name                = "liliekscluster"  //provide your Cluster Name here
  eks_version                 = "1.26"
  ami_type                    = "AL2_x86_64"
  instance_types              = ["t3.small", "t3.medium", "t3.large"]
  capacity_type               = "ON_DEMAND"
   # Pass VPC-related information from my_vpc module to my_eks module
  private_subnet_ids          = module.vpc.private_subnet_ids
  public_subnet_ids           = module.vpc.public_subnet_ids
}
