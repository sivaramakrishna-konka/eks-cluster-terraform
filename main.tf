# VPC 
module "eks_vpc" {
  source              = "./modules/vpc"
  environment         = var.common_envs["environment"]
  project             = var.common_envs["project"]
  common_tags         = var.common_tags
  vpc_cidr            = var.vpc["vpc_cidr"]
  azs                 = var.vpc["azs"]
  public_subnet_cidr  = var.vpc["public_subnet_cidr"]
  private_subnet_cidr = var.vpc["private_subnet_cidr"]
  db_subnet_cidr      = var.vpc["db_subnet_cidr"]
  enable_nat          = var.vpc["enable_nat"]
}

# EKS Cluster
module "eks_control_plane" {
  depends_on       = [module.eks_vpc]
  source           = "./modules/eks"
  region           = var.region
  profile          = var.profile
  environment      = var.common_envs["environment"]
  project          = var.common_envs["project"]
  vpc_id           = module.eks_vpc.vpc_id
  vpc_cidr         = var.vpc["vpc_cidr"]
  subnet_ids       = module.eks_vpc.private_subnet_ids
  cluster_version  = var.eks["cluster_version"]
  node_groups      = var.eks["node_groups"]
  key_name         = var.eks["key_name"]
  eks_access_entry = var.eks["eks_access_entry"]
  eks_addons       = var.eks["eks_addons"]
}
# Bastion Host
module "machine" {
  depends_on           = [module.eks_control_plane]
  source               = "./modules/ec2"
  environment          = var.common_envs["environment"]
  project              = var.common_envs["project"]
  instance_type        = var.bastion["instance_type"]
  common_tags          = var.common_tags
  key_name             = var.eks["key_name"]
  subnet_id            = module.eks_vpc.public_subnet_ids[0]
  instance_name        = var.bastion["instance_name"]
  vpc_id               = module.eks_vpc.vpc_id
  zone_id              = var.bastion["zone_id"]
  iam_instance_profile = var.bastion["iam_instance_profile"]
}