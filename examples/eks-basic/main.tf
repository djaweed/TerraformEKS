module "vpc" {
  source             = "../../modules/vpc"
  name               = "eks-demo"
  cidr_block         = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]
  tags = {
    Project = "EKS"
    Environment = "dev"
  }
}


module "eks_cluster" {
  source     = "../../modules/eks-cluster"
  name       = "eks-demo"
  subnet_ids = module.vpc.public_subnet_ids
}

module "eks_node_group" {
  source       = "../../modules/eks-node-group"
  name         = "eks-demo"
  cluster_name = module.eks_cluster.cluster_name
  subnet_ids   = module.vpc.public_subnet_ids
}

module "eks_addons" {
  source       = "../../modules/eks-addons"
  cluster_name = module.eks_cluster.cluster_name
  region       = "us-east-1"
  vpc_id       = module.vpc.vpc_id
}
