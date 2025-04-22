#######################################################################
#                         EKS CLuster Security Group                  #
#######################################################################
resource "aws_security_group" "cluster-sg" {
  name        = "${var.environment}-${var.project}-eks-cluster-sg"
  description = "${var.environment}-${var.project}eks-cluster-sg"
  vpc_id      = var.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = {
    Name = "${var.environment}-${var.project}-eks-cluster-sg"
  }
}

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

resource "aws_iam_role" "cluster" {
  name = "eks-cluster-example"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}