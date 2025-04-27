region      = "ap-south-1"
profile     = "eks-siva.bapatlas.site"
common_tags = {
  "Environment" = "development"
  "Project"     = "eks"
  "Owner"       = "sivaramakrishna"
  "Terraform"   = "v1.11.3"
  "ManagedBy"   = "Terraform"
  "AWS Version" = "5.94.1"
}
common_envs = {
  "environment" = "dev"
  "project"     = "eks"
}
vpc = {
  vpc_cidr = "10.1.0.0/16"
  azs = ["ap-south-1a","ap-south-1b"]
  public_subnet_cidr = ["10.1.1.0/24","10.1.2.0/24"]
  private_subnet_cidr = ["10.1.4.0/24","10.1.5.0/24"]
  db_subnet_cidr = ["10.1.8.0/24","10.1.9.0/24"]
  enable_nat = true
}
# # eks cluster values
# cluster_version = "1.30"
# authentication_mode = "API_AND_CONFIG_MAP"
# bootstrap_cluster_creator_admin_permissions = true
# # node group values
# node_instance_type = ["t3a.medium"]
# capacity_type = "ON_DEMAND"
# min_size = 1
# max_size = 2
# desired_size = 2
# # ec2 values
# zone_id = "Z011675617HENPLWZ1EJC"
# instance_type = "t3.micro"
# iam_instance_profile = "siva"