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
    depends_on                                  = [module.eks_vpc]
    source                                      = "./modules/eks"
    environment                                 = var.environment
    project                                     = var.project
    vpc_id                                      = module.eks_vpc.vpc_id
    vpc_cidr                                    = var.vpc_cidr
    private_subnet_ids                          = module.eks_vpc.private_subnet_ids
    cluster_version                             = var.cluster_version
    authentication_mode                         = var.authentication_mode
    bootstrap_cluster_creator_admin_permissions = var.bootstrap_cluster_creator_admin_permissions
}

module "machine"{
  depends_on = [ module.eks_vpc ]
  source = "./modules/ec2"
  environment = var.environment
  project = var.project
  instance_type = var.instance_type
  common_tags = var.common_tags
  key_name = var.key_name
  subnet_id = module.eks_vpc.public_subnet_ids[0]
  instance_name = "admins-bastion"
  vpc_id = module.eks_vpc.vpc_id
  zone_id = var.zone_id
}