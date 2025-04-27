#########################################################################
#                    EKS Control Plane                                  #
#########################################################################
resource "aws_eks_cluster" "example" {
  name = "${var.environment}-${var.project}"

  access_config {
    authentication_mode = var.authentication_mode
    bootstrap_cluster_creator_admin_permissions = var.bootstrap_cluster_creator_admin_permissions
  }

  role_arn = aws_iam_role.cluster.arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids = var.subnet_ids
    security_group_ids = [aws_security_group.cluster-sg.id]
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}
############################################################################
#                   Launch Template                                        #        
############################################################################

# resource "aws_launch_template" "main" {
#   for_each = var.node_groups
#   name     = each.key
#   key_name = var.key_name

#   block_device_mappings {
#     device_name = "/dev/xvda"
#     ebs {
#       volume_size = 30
#       encrypted   = true
#     }
#   }

#   tag_specifications {
#     resource_type = "instance"
#     tags = {
#       Name = each.key
#     }
#   }
# }
# ##############################################################################
# #                   NodeGroup                                                #
# ##############################################################################
# resource "aws_eks_node_group" "main" {
#   depends_on = [ aws_eks_cluster.example ]
#   for_each        = var.node_groups
#   cluster_name    = aws_eks_cluster.example.name
#   node_group_name = each.key
#   node_role_arn   = aws_iam_role.example.arn
#   subnet_ids      = var.subnet_ids
#   instance_types  = each.value["instance_types"]
#   capacity_type   = each.value["capacity_type"]

#   launch_template {
#     name    = each.key
#     version = "$Latest"
#   }

#   scaling_config {
#     desired_size = each.value["desired_size"]
#     max_size     = each.value["max_size"]
#     min_size     = each.value["min_size"]
#   }
# }
#################################################################################
#                          Uer Access Entry                                     #
#################################################################################
# module "eks_iam_access_entry" {
#   source            = "./eks_access_entry"
#   for_each = var.eks_access_entry
#   cluster_name      = aws_eks_cluster.example.name
#   principal_arn     = each.value["principal_arn"]
#   kubernetes_groups = each.value["kubernetes_groups"]
#   policy_arn        = each.value["policy_arn"]
# }
#################################################################################
#                          Addons                                               #
#################################################################################
# module "eks_addons" {
#   depends_on = [ aws_eks_cluster.example ]
#   source = "./addons"
#   for_each = var.eks_addons
#   cluster_name = aws_eks_cluster.example.name
#   addon_name = each.key
#   addon_version = each.value
# }