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

# module "eks_cluster" {
#   depends_on                                  = [module.eks_vpc]
#   source                                      = "./modules/eks"
#   environment                                 = var.environment
#   project                                     = var.project
#   region                                      = var.region
#   vpc_id                                      = module.eks_vpc.vpc_id
#   vpc_cidr                                    = var.vpc_cidr
#   subnet_ids                                  = module.eks_vpc.public_subnet_ids
#   cluster_version                             = var.cluster_version
#   authentication_mode                         = var.authentication_mode
#   bootstrap_cluster_creator_admin_permissions = var.bootstrap_cluster_creator_admin_permissions
#   key_name                                    = var.key_name
#   node_groups = {
#     blue = {
#       instance_types = var.node_instance_type
#       capacity_type  = var.capacity_type
#       min_size       = var.min_size
#       max_size       = var.max_size
#       desired_size   = var.desired_size
#     }
#   }
#   eks_access_entry = {
#     admin-user = {
#       principal_arn     = "arn:aws:iam::522814728660:root"
#       policy_arn        = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
#       kubernetes_groups = []
#     }
#     eks-dev = {
#       principal_arn     = "arn:aws:iam::522814728660:role/siva"
#       policy_arn        = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
#       kubernetes_groups = []
#     }
#   }
#   eks_addons = {
#     vpc-cni = "v1.19.0-eksbuild.1"
#     coredns                = "v1.11.1-eksbuild.8"
#     metrics-server         = "v0.7.2-eksbuild.3"
#     aws-ebs-csi-driver     = "v1.42.0-eksbuild.1"
#     eks-pod-identity-agent = "v1.3.4-eksbuild.1"
#   }
# }


# module "machine" {
#   depends_on           = [module.eks_vpc, module.eks_cluster]
#   source               = "./modules/ec2"
#   environment          = var.environment
#   project              = var.project
#   instance_type        = var.instance_type
#   common_tags          = var.common_tags
#   key_name             = var.key_name
#   subnet_id            = module.eks_vpc.public_subnet_ids[0]
#   instance_name        = "admins-bastion"
#   vpc_id               = module.eks_vpc.vpc_id
#   zone_id              = var.zone_id
#   iam_instance_profile = var.iam_instance_profile
# }