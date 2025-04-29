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
eks = {
  cluster_version = "1.31"
  key_name = "siva"
  node_groups = {
    eks_node_group_blue = {
      instance_types = ["t3a.medium"]
      capacity_type  = "ON_DEMAND"
      min_size       = 1
      max_size       = 6
      desired_size   = 6
    }
  }
  eks_access_entry = {
    admin-user = {
      principal_arn     = "arn:aws:iam::522814728660:root"
      policy_arn        = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
      kubernetes_groups = []
    }
    bastion-host = {
      principal_arn     = "arn:aws:iam::522814728660:role/siva"
      policy_arn        = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
      kubernetes_groups = []
    }
    project-2 = {
      principal_arn     = "arn:aws:iam::522814728660:role/proj-2"
      policy_arn        = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
      kubernetes_groups = ["proj-2-rolebinding"]
    }
  }
  eks_addons = {
    vpc-cni = "v1.19.4-eksbuild.1"
    coredns = "v1.11.4-eksbuild.2"
    eks-pod-identity-agent = "v1.3.5-eksbuild.2"
  }
}

bastion = {
  instance_type = "t3.micro"
  instance_name = "bastion"
  iam_instance_profile = "siva"
  zone_id = "Z011675617HENPLWZ1EJC"
}

# aws eks describe-addon-versions --addon-name vpc-cni