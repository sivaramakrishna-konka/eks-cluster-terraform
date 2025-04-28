resource "null_resource" "kube-config" {
  depends_on = [aws_eks_cluster.example,aws_eks_node_group.main]

  provisioner "local-exec" {
    command = <<EOF
set -e
aws eks update-kubeconfig --name ${aws_eks_cluster.example.name} --region ${var.region} --profile ${var.profile}
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/high-availability-1.21+.yaml
EOF
  }
}

resource "helm_release" "aws_ebs_csi_driver" {
  depends_on = [null_resource.kube-config]
  name       = "aws-ebs-csi-driver"
  namespace  = "kube-system"

  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  set {
    name  = "controller.serviceAccount.create"
    value = "true"
  }

  set {
    name  = "controller.serviceAccount.name"
    value = "ebs-csi-controller-sa"
  }
}

# resource "helm_release" "aws-controller-ingress" {

#   depends_on = [null_resource.kube-config]

#   name       = "aws-ingress"
#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller"
#   namespace  = "kube-system"
#   wait       = "false"

#   set {
#     name  = "clusterName"
#     value = aws_eks_cluster.example.id
#   }

#   set {
#     name  = "vpcId"
#     value = var.vpc_id
#   }
# }
