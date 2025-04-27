# EKS CLuster Security Group
resource "aws_security_group" "cluster_sg" {
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
# EKS CLuster NodeGroup Security Group
resource "aws_security_group" "node_sg" {
  name        = "${var.environment}-${var.project}-eks-cluster-node-sg"
  description = "${var.environment}-${var.project}eks-cluster-node-sg"
  vpc_id      = var.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [aws_security_group.cluster_sg.id]
  }

  tags = {
    Name = "${var.environment}-${var.project}-eks-cluster-node-sg"
  }
}