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
    subnet_ids = var.private_subnet_ids
    security_group_ids = [aws_security_group.cluster-sg.id]
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}
############################################################################
#                   Launch Template                                        #        
############################################################################

# resource "aws_launch_template" "foo" {
#   for_each = var.node_group
#   name = each.key

#   block_device_mappings {
#     device_name = "/dev/xvda"
#     ebs {
#       volume_size = 20
#       volume_type = "gp3"
#       delete_on_termination = true
#     }
#   }

#   tag_specifications {
#     resource_type = "instance"

#     tags = merge(
#       {
#       Name = each.key
#       },
#       var.common_tags
#       )
#   }
# }

##############################################################################
#                   NodeGroup                                                #
##############################################################################
# resource "aws_eks_node_group" "example" {
#   for_each         = var.node_group
#   cluster_name     = aws_eks_cluster.example.name
#   node_group_name  = each.key
#   node_role_arn    = aws_iam_role.example.arn
#   subnet_ids       = var.private_subnet_ids
#   instance_types   = [each.value["instance_types"]]
#   launch_template {
#     id      = aws_launch_template.foo.id
#     version = "$Latest"
#   }

#   scaling_config {
#     desired_size = each.value["desired_size"]
#     max_size     = each.value["max_size"]
#     min_size     = each.value["min_size"]
#   }

#   update_config {
#     max_unavailable = 1
#   }

#   # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
#   # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
#   depends_on = [
#     aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
#     aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
#     aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
#   ]
# }













#################################################################################
#                          Uer Access Entry                                     #
#################################################################################
module "eks_iam_access_entry" {
  source            = "./eks_access_entry"
  for_each = var.eks_access_entry
  cluster_name      = aws_eks_cluster.example.name
  principal_arn     = each.value["principal_arn"]
  kubernetes_groups = each.value["kubernetes_groups"]
  policy_arn        = each.value["policy_arn"]
}
