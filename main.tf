module "eks_vpc" {
  source              = "./modules/vpc"
  environment         = var.environment
  project             = var.project
  common_tags         = var.common_tags
  vpc_cidr            = var.vpc_cidr
  azs                 = var.azs
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  db_subnet_cidr      = var.db_subnet_cidr
  enable_nat          = var.enable_nat
}

module "eks_cluster" {
  depends_on = [ module.eks_vpc ]
  source = "./modules/eks"
  environment = var.environment
  project     = var.project
  vpc_id = module.eks_vpc.vpc_id
  vpc_cidr = var.vpc_cidr
  private_subnet_ids = module.eks_vpc.private_subnet_ids
  cluster_version = var.cluster_version
  authentication_mode = var.authentication_mode
  bootstrap_cluster_creator_admin_permissions = var.bootstrap_cluster_creator_admin_permissions
}