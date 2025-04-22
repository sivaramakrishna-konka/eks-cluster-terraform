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

resource "aws_launch_template" "foo" {
  name = "${var.environment}-${var.project}-launch-template"

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
      volume_type = "gp3"
      delete_on_termination = true
    }
  }

  instance_type = "t3a.medium"
  vpc_security_group_ids = [aws_security_group.node-sg.id]

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      {
      Name = "${var.environment}-${var.project}-launch-template"
      },
      var.common_tags
      )
  }
}
