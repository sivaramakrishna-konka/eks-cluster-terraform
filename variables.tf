variable "common_envs" {}
variable "common_tags" {}
variable "vpc" {}
variable "region" {}
variable "profile" {}
##################################################################################
#                     EKS Cluster Variables                                      #
##################################################################################
# variable "cluster_version" {
#   description = "The EKS cluster version"
#   type        = string
# }

# variable "authentication_mode" {
#   description = "The authentication mode for the EKS cluster"
#   type        = string
# }
# variable "bootstrap_cluster_creator_admin_permissions" {
#   description = "Whether to grant admin permissions to the bootstrap cluster creator"
#   type        = bool
#   default     = false
# }

##################################################################################
#                     NodeGroup Variables                                        #
##################################################################################
# variable "node_instance_type" {}
# variable "capacity_type" {}
# variable "min_size" {}
# variable "max_size" {}
# variable "desired_size" {}

####################################################################################
#                      EC2 Variables                                               #    
####################################################################################
# variable "instance_type" {
#   description = "The instance type for the EC2 instance"
#   type        = string
# }
# variable "key_name" {
#   description = "The name of the key pair to use for SSH access"
#   type        = string
# }
# variable "zone_id" {
#   description = "The Route 53 zone ID for the domain"
#   type        = string
# }
# variable "iam_instance_profile" {
#   description = "The IAM instance profile for the EC2 instance"
#   type        = string
# }