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

variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}


######################################################################################
#               EKS Control Plance                                                   #
######################################################################################
variable "subnet_ids" {
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

#########################################################################################
#               Cluser user Access                                                      #
#########################################################################################

# variable "eks_access_entry" {
#   description = "enter the list of user access entry"
#   type        = map(object({
#     principal_arn     = string
#     policy_arn        = string
#     kubernetes_groups = list(string)
#   }))
# }


# #########################################################################################
# #                Launch Template                                                        #
# #########################################################################################
# variable "node_groups" {}
# variable "key_name" {
#   description = "The name of the key pair to use for SSH access to the instances"
#   type        = string
# }

# ##########################################################################################
# #                            Addons                                                      #
# ##########################################################################################
# variable "eks_addons" {}

# variable "region" {
#   description = "The AWS region to deploy the resources in"
#   type        = string
# }