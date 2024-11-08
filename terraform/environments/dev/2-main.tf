terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.72.1"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "VPC" {
  source                = "../../modules/vpc"
  cluster_name          = var.cluster_name
  created_by            = var.created_by
  aws_region            = var.aws_region
  vpc_cidr_block        = var.vpc_cidr_block
  subnet_public-1_cidr  = var.subnet_public-1_cidr
  subnet_public-2_cidr  = var.subnet_public-2_cidr
  subnet_private-1_cidr = var.subnet_private-1_cidr
  subnet_private-2_cidr = var.subnet_private-2_cidr
}



module "EKS" {
  source                 = "../../modules/eks"
  created_by             = var.created_by
  cluster_name           = var.cluster_name
  aws_region             = var.aws_region
  vpc_cidr_block         = var.vpc_cidr_block
  subnet_public-1_cidr   = var.subnet_public-1_cidr
  subnet_public-2_cidr   = var.subnet_public-2_cidr
  subnet_private-1_cidr  = var.subnet_private-1_cidr
  subnet_private-2_cidr  = var.subnet_private-2_cidr
  subnet_id_private_1    = module.VPC.subnet_id_private_1
  subnet_id_private_2    = module.VPC.subnet_id_private_2
  EKS_Kubernetes_Version = var.EKS_Kubernetes_Version
  private_nodegroup_1    = var.private_nodegroup_1
}

