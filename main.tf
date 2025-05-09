module "vpc" {
  source           = "./modules/vpc"
  region           = "us-west-2"
  vpc_cidr         = "10.0.0.0/16"
  public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  azs              = ["us-west-2a", "us-west-2b"]
}

module "iam" {
  source            = "./modules/iam"
  cluster_role_name = "eks-cluster-role"
  node_role_name    = "eks-node-role"
}

module "eks" {
  source             = "./modules/eks"
  cluster_name       = "eks-cluster"
  region             = "us-west-2"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids
  cluster_role_arn   = module.iam.cluster_role_arn
  node_role_arn      = module.iam.node_role_arn

  desired_capacity   = 3
  min_size           = 2
  max_size           = 5
  instance_types     = ["t3.medium"]
  eks_version        = "1.29"
}