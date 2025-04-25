## 📁 Terraform Infrastructure Folder Structure – Overview

```
.
├── README.md                          # Project overview & usage guide
├── environments/                      # Environment-specific configs
│   ├── development/
│   │   ├── backend.tfvars             # Backend config (e.g., S3 bucket, DynamoDB lock table)
│   │   └── main.tfvars                # Dev environment variable values
│   └── production/
│       ├── backend.tfvars             # Backend config for prod
│       └── main.tfvars                # Production-specific variables
├── main.tf                            # Root configuration using modules (VPC, EC2, EKS, etc.)
├── outputs.tf                         # Declares outputs like EKS cluster name, VPC ID, etc.
├── provider.tf                        # Provider configuration (e.g., AWS region, version)
├── variables.tf                       # Input variables used across all modules
└── modules/                           # Reusable infrastructure modules
    ├── ec2/
    │   ├── main.tf                    # EC2 instance setup (AMI, SG, etc.)
    │   ├── outputs.tf
    │   ├── utilities.sh               # Optional: Bash script for bootstrapping EC2
    │   └── variables.tf
    └── eks/
        ├── eks_access_entry/
        │   └── main.tf                # EKS access entries (e.g., RBAC config)
        ├── iam.tf                     # IAM roles/policies needed by EKS
        ├── main.tf                    # Main EKS setup (cluster, node group, etc.)
        └── variables.tf
```

---

## 🚀 Common Terraform Commands for Each Environment

> 💡 Replace `development` with `production` as needed.

### 🔹 1. **Initialize Terraform**
```bash
terraform init -backend-config=environments/development/backend.tfvars
```

### 🔹 2. **Format Code**
```bash
terraform fmt
```

### 🔹 3. **Validate Config**
```bash
terraform validate
```

### 🔹 4. **Plan Infrastructure Changes**
```bash
terraform plan -var-file=environments/development/main.tfvars
```

### 🔹 5. **Apply Changes**
```bash
terraform apply -var-file=environments/development/main.tfvars -auto-approve
```

### 🔹 6. **Destroy Resources**
```bash
terraform destroy -var-file=environments/development/main.tfvars -auto-approve
```

---

## ✅ Benefits of This Structure

- **Environment isolation** via separate `tfvars` files and backends
- **Modularity** with reusable `modules/` (helps with DRY code and easier testing)
- **Scalability** as you grow from dev to staging to prod
- **Team-friendly** by separating configuration from logic
---

```markdown
# 🛠️ Development Approach for Infrastructure Required for EKS Cluster

## 🔹 VPC (Provides Networking)
- 2 public, 2 private, and 2 DB subnets
- Route tables for each subnet group:
  - Public route table for public subnets
  - Private route table for private subnets
  - DB route table for DB subnets
- Subnet associations with respective route tables
- Routes configured in each route table
- DB Subnet Group for RDS usage
- Elastic IP for NAT Gateway
- Single NAT Gateway used for both private and DB subnets
- NAT routes added to private and DB route tables

## 🔹 EC2 (Bastion Host for Accessing EKS Cluster)
- EC2 instance with Bash script for tool installation
- Route53 record creation for access
- Null resource used to run the Bash script remotely

## 🔹 EKS Module
- IAM roles and policies for:
  - EKS control plane
  - Node groups
- Security Groups:
  - For EKS control plane
  - For EKS node groups

### 🔸 Sub-modules within EKS
- `addons/` – EKS add-ons like CoreDNS, kube-proxy, etc.
- `eks_access_entry/` – IAM and role binding configurations for access control
```
