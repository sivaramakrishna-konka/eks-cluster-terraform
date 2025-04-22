##################################################################################
# Provider Variables
##################################################################################
variable "region" {
  description = "The AWS region to deploy the VPC"
  type        = string
  default     = "ap-south-1"
}
variable "profile" {
  description = "The AWS profile to use for authentication"
  type        = string
  default     = "eks-siva.bapatlas.site"
}

###################################################################################
# Common Variables
###################################################################################
variable "environment" {
  description = "The environment for the VPC (e.g., dev, staging, prod)"
  type        = string
}
variable "project" {
  description = "The project name for the VPC"
  type        = string
}
variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

####################################################################################
# VPC Variables
####################################################################################

variable "vpc_cidr" {
  description = "value of the VPC CIDR block"
  type        = string
}

#########################################################################
# Subnet Variables
#########################################################################
variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = list(string)
}
variable "azs" {
  description = "List of availability zones for the subnets"
  type        = list(string)
}
variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = list(string)
}
variable "db_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = list(string)
}
variable "enable_nat" {
  type    = bool
  default = true
}

##################################################################################
#                     EKS Cluster Variables                                      #
##################################################################################
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

####################################################################################
#                      EC2 Variables                                               #    
####################################################################################
variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
}
variable "key_name" {
  description = "The name of the key pair to use for SSH access"
  type        = string
}
variable "zone_id" {
  description = "The Route 53 zone ID for the domain"
  type        = string  
}