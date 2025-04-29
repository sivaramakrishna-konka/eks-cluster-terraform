# Update kubeconfig
resource "null_resource" "kube-config" {
  depends_on = [aws_eks_cluster.example,aws_eks_node_group.main]

  provisioner "local-exec" {
    command = <<EOF
aws eks update-kubeconfig --name ${aws_eks_cluster.example.name} --region ${var.region} --profile ${var.profile}
EOF
  }
}

# Metrics Server
resource "null_resource" "metrics-server" {
  depends_on = [null_resource.kube-config]

  provisioner "local-exec" {
    command = <<EOF
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/high-availability-1.21+.yaml
EOF
  }
}

# AWS EBS CSI Driver
resource "null_resource" "ebs-csi-driver" {
  depends_on = [null_resource.kube-config]

  provisioner "local-exec" {
    command = <<EOF
kubectl apply -k github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.42
EOF
  }
}

# AWS ALB Ingress Controller
resource "helm_release" "aws-controller-ingress" {

  depends_on = [null_resource.kube-config]

  name       = "aws-ingress"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  wait       = "false"

  set {
    name  = "clusterName"
    value = aws_eks_cluster.example.name
  }

  set {
    name  = "vpcId"
    value = var.vpc_id
  }
}

# ExternalDNS
resource "helm_release" "external_dns" {
  depends_on = [null_resource.kube-config]
  name       = "external-dns"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  
  set {
    name  = "serviceAccount.name"
    value = "external-dns"
  }
}
