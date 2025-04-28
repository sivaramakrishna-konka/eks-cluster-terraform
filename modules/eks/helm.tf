resource "null_resource" "kube-config" {
  depends_on = [aws_eks_cluster.example]

  provisioner "local-exec" { 
    command = "aws eks update-kubeconfig --name ${aws_eks_cluster.example.name} --region ${var.region} --profile ${var.profile}" 
  }
}

resource "null_resource" "utilities" {
  depends_on = [null_resource.kube-config]

  provisioner "local-exec" { 
    command = "kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/aws/deploy.yaml" 
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
