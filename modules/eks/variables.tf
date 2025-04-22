####################################################################################
#               variable eks cluster sg                                            #
####################################################################################
variable "environment" {
  description = "The environment for the VPC (e.g., dev, staging, prod)"
  type        = string
}

variable "project" {
  description = "The project name for the VPC"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the security group will be created"
  type        = string
}

variable "vpc_cidr" {
  description = "The VPC CIDR block"
  type        = string
}

######################################################################################
#               EKS Control Plance                                                   #
######################################################################################
variable "private_subnet_ids" {
  description = "List of private subnet IDs for the EKS cluster"
  type        = list(string)
}
variable "cluster_version" {
  description = "The EKS cluster version"
  type        = string
}

variable "authentication_mode" {
  description = "The authentication mode for the EKS cluster"
  type        = string  
}
variable "bootstrap_cluster_creator_admin_permissions" {
  description = "Whether to grant admin permissions to the bootstrap cluster creator"
  type        = bool
  default     = false
}