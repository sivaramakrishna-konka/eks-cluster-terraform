# common values
region      = "ap-south-1"
environment = "dev"
project     = "eks"
key_name = "siva"
common_tags = {
  "Environment" = "development"
  "Project"     = "eks"
  "Owner"       = "sivaramakrishna"
  "Terraform"   = "v1.11.3"
  "ManagedBy"   = "Terraform"
  "AWS Version" = "5.94.1"
}
# vpc values
vpc_cidr = "10.1.0.0/16"
azs = ["ap-south-1a","ap-south-1b"]
public_subnet_cidr = ["10.1.1.0/24","10.1.2.0/24"]
private_subnet_cidr = ["10.1.4.0/24","10.1.5.0/24"]
db_subnet_cidr = ["10.1.8.0/24","10.1.9.0/24"]
enable_nat = false
# eks cluster values
cluster_version = "1.30"
authentication_mode = "API_AND_CONFIG_MAP"
bootstrap_cluster_creator_admin_permissions = true
node_groups = {
    blue = {
      node_instance_type = "t3a.medium"
      capacity_type = "ON_DEMAND"
      min_size = 1
      max_size = 2
      desired_size = 2
    }
}
eks_access_entry = {
    admin-user = {
      principal_arn     = "arn:aws:iam::522814728660:root"
      policy_arn        = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
      kubernetes_groups = []
    }
    eks-dev = {
      principal_arn     = "arn:aws:iam::522814728660:role/siva"
      policy_arn        = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
      kubernetes_groups = []
    }
}
eks_addons = {
  vpc-cni                = "v1.19.0-eksbuild.1"
  coredns                = "v1.11.1-eksbuild.8"
  metrics-server         = "v0.7.2-eksbuild.3"
  aws-ebs-csi-driver     = "v1.42.0-eksbuild.1"
  eks-pod-identity-agent = "v1.3.4-eksbuild.1"
}

# ec2 values
zone_id = "Z011675617HENPLWZ1EJC"
instance_type = "t3.micro"
iam_instance_profile = "siva"