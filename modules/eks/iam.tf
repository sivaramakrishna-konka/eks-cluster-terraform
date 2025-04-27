# Control Plane IAM Role
resource "aws_iam_role" "cluster" {
  name = "${var.environment}-${var.project}-eks-cluster-example"
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
  tags = {
  Environment = var.environment
  Project     = var.project
  Terraform   = "true"
}
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}
# Node Group IAM Role
resource "aws_iam_role" "example" {
  name = "${var.environment}-${var.project}-eks-nodegroup-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  tags = {
  Environment = var.environment
  Project     = var.project
  Terraform   = "true"
}
}

resource "aws_iam_role_policy_attachment" "node_policy" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ])
  policy_arn = each.value
  role       = aws_iam_role.example.name
}
# ##################################################################################
# #             IAM,ROle,Policy EBS CSI Controller  Pod identity                   #
# ##################################################################################

# resource "aws_iam_role" "ebs_csi_controller_role" {
#   name = "${var.environment}-${var.project}-ebs-csi-controller-role"
#   assume_role_policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Effect" : "Allow",
#         "Principal" : {
#           "Service" : [
#             "pods.eks.amazonaws.com"
#           ]
#         },
#         "Action" : [
#           "sts:AssumeRole",
#           "sts:TagSession"
#         ]
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy" "test_policy" {
#   name = "${var.environment}-${var.project}-ebs-csi-controller-policy"
#   depends_on = [aws_iam_role.ebs_csi_controller_role]
#   role = aws_iam_role.ebs_csi_controller_role.id

#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Effect": "Allow",
#         "Action": [
#           "ec2:DescribeAvailabilityZones",
#           "ec2:DescribeInstances",
#           "ec2:DescribeSnapshots",
#           "ec2:DescribeTags",
#           "ec2:DescribeVolumes",
#           "ec2:DescribeVolumesModifications"
#         ],
#         "Resource": "*"
#       },
#       {
#         "Effect": "Allow",
#         "Action": [
#           "ec2:CreateSnapshot",
#           "ec2:ModifyVolume"
#         ],
#         "Resource": "arn:aws:ec2:*:*:volume/*"
#       },
#       {
#         "Effect": "Allow",
#         "Action": [
#           "ec2:AttachVolume",
#           "ec2:DetachVolume"
#         ],
#         "Resource": [
#           "arn:aws:ec2:*:*:volume/*",
#           "arn:aws:ec2:*:*:instance/*"
#         ]
#       },
#       {
#         "Effect": "Allow",
#         "Action": [
#           "ec2:CreateVolume",
#           "ec2:EnableFastSnapshotRestores"
#         ],
#         "Resource": "arn:aws:ec2:*:*:snapshot/*"
#       },
#       {
#         "Effect": "Allow",
#         "Action": [
#           "ec2:CreateTags"
#         ],
#         "Resource": [
#           "arn:aws:ec2:*:*:volume/*",
#           "arn:aws:ec2:*:*:snapshot/*"
#         ],
#         "Condition": {
#           "StringEquals": {
#             "ec2:CreateAction": [
#               "CreateVolume",
#               "CreateSnapshot"
#             ]
#           }
#         }
#       },
#       {
#         "Effect": "Allow",
#         "Action": [
#           "ec2:DeleteTags"
#         ],
#         "Resource": [
#           "arn:aws:ec2:*:*:volume/*",
#           "arn:aws:ec2:*:*:snapshot/*"
#         ]
#       },
#       {
#         "Effect": "Allow",
#         "Action": [
#           "ec2:CreateVolume"
#         ],
#         "Resource": "arn:aws:ec2:*:*:volume/*",
#         "Condition": {
#           "StringLike": {
#             "aws:RequestTag/ebs.csi.aws.com/cluster": "true"
#           }
#         }
#       },
#       {
#         "Effect": "Allow",
#         "Action": [
#           "ec2:CreateVolume"
#         ],
#         "Resource": "arn:aws:ec2:*:*:volume/*",
#         "Condition": {
#           "StringLike": {
#             "aws:RequestTag/CSIVolumeName": "*"
#           }
#         }
#       },
#       {
#         "Effect": "Allow",
#         "Action": [
#           "ec2:DeleteVolume"
#         ],
#         "Resource": "arn:aws:ec2:*:*:volume/*",
#         "Condition": {
#           "StringLike": {
#             "ec2:ResourceTag/ebs.csi.aws.com/cluster": "true"
#           }
#         }
#       },
#       {
#         "Effect": "Allow",
#         "Action": [
#           "ec2:DeleteVolume"
#         ],
#         "Resource": "arn:aws:ec2:*:*:volume/*",
#         "Condition": {
#           "StringLike": {
#             "ec2:ResourceTag/CSIVolumeName": "*"
#           }
#         }
#       },
#       {
#         "Effect": "Allow",
#         "Action": [
#           "ec2:DeleteVolume"
#         ],
#         "Resource": "arn:aws:ec2:*:*:volume/*",
#         "Condition": {
#           "StringLike": {
#             "ec2:ResourceTag/kubernetes.io/created-for/pvc/name": "*"
#           }
#         }
#       },
#       {
#         "Effect": "Allow",
#         "Action": [
#           "ec2:CreateSnapshot"
#         ],
#         "Resource": "arn:aws:ec2:*:*:snapshot/*",
#         "Condition": {
#           "StringLike": {
#             "aws:RequestTag/CSIVolumeSnapshotName": "*"
#           }
#         }
#       },
#       {
#         "Effect": "Allow",
#         "Action": [
#           "ec2:CreateSnapshot"
#         ],
#         "Resource": "arn:aws:ec2:*:*:snapshot/*",
#         "Condition": {
#           "StringLike": {
#             "aws:RequestTag/ebs.csi.aws.com/cluster": "true"
#           }
#         }
#       },
#       {
#         "Effect": "Allow",
#         "Action": [
#           "ec2:DeleteSnapshot"
#         ],
#         "Resource": "arn:aws:ec2:*:*:snapshot/*",
#         "Condition": {
#           "StringLike": {
#             "ec2:ResourceTag/CSIVolumeSnapshotName": "*"
#           }
#         }
#       },
#       {
#         "Effect": "Allow",
#         "Action": [
#           "ec2:DeleteSnapshot"
#         ],
#         "Resource": "arn:aws:ec2:*:*:snapshot/*",
#         "Condition": {
#           "StringLike": {
#             "ec2:ResourceTag/ebs.csi.aws.com/cluster": "true"
#           }
#         }
#       }
#     ]
#   })
# }

# resource "aws_eks_pod_identity_association" "example" {
#   cluster_name    = aws_eks_cluster.example.name
#   namespace       = "kube-system"
#   service_account = "ebs-csi-controller-sa"
#   role_arn        = aws_iam_role.ebs_csi_controller_role.arn
# }

# ##################################################################################
# #         IAM,ROle,Policy aws-load-balancer-controller   Pod identity            #
# ##################################################################################
# resource "aws_iam_role" "aws_alb_controller_role" {
#   name = "${var.environment}-${var.project}-aws-load-balancer-controller"
#   assume_role_policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Effect" : "Allow",
#         "Principal" : {
#           "Service" : [
#             "pods.eks.amazonaws.com"
#           ]
#         },
#         "Action" : [
#           "sts:AssumeRole",
#           "sts:TagSession"
#         ]
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy" "aws_alb_controller_role_policy" {
#   name = "${var.environment}-${var.project}-aws-load-balancer-controller-policy"
#   depends_on = [aws_iam_role.aws_alb_controller_role]
#   role = aws_iam_role.aws_alb_controller_role.id

#   policy = jsonencode(
#     {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "iam:CreateServiceLinkedRole"
#             ],
#             "Resource": "*",
#             "Condition": {
#                 "StringEquals": {
#                     "iam:AWSServiceName": "elasticloadbalancing.amazonaws.com"
#                 }
#             }
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "ec2:DescribeAccountAttributes",
#                 "ec2:DescribeAddresses",
#                 "ec2:DescribeAvailabilityZones",
#                 "ec2:DescribeInternetGateways",
#                 "ec2:DescribeVpcs",
#                 "ec2:DescribeVpcPeeringConnections",
#                 "ec2:DescribeSubnets",
#                 "ec2:DescribeSecurityGroups",
#                 "ec2:DescribeInstances",
#                 "ec2:DescribeNetworkInterfaces",
#                 "ec2:DescribeTags",
#                 "ec2:GetCoipPoolUsage",
#                 "ec2:DescribeCoipPools",
#                 "ec2:GetSecurityGroupsForVpc",
#                 "ec2:DescribeIpamPools",
#                 "ec2:DescribeRouteTables",
#                 "elasticloadbalancing:DescribeLoadBalancers",
#                 "elasticloadbalancing:DescribeLoadBalancerAttributes",
#                 "elasticloadbalancing:DescribeListeners",
#                 "elasticloadbalancing:DescribeListenerCertificates",
#                 "elasticloadbalancing:DescribeSSLPolicies",
#                 "elasticloadbalancing:DescribeRules",
#                 "elasticloadbalancing:DescribeTargetGroups",
#                 "elasticloadbalancing:DescribeTargetGroupAttributes",
#                 "elasticloadbalancing:DescribeTargetHealth",
#                 "elasticloadbalancing:DescribeTags",
#                 "elasticloadbalancing:DescribeTrustStores",
#                 "elasticloadbalancing:DescribeListenerAttributes",
#                 "elasticloadbalancing:DescribeCapacityReservation"
#             ],
#             "Resource": "*"
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "cognito-idp:DescribeUserPoolClient",
#                 "acm:ListCertificates",
#                 "acm:DescribeCertificate",
#                 "iam:ListServerCertificates",
#                 "iam:GetServerCertificate",
#                 "waf-regional:GetWebACL",
#                 "waf-regional:GetWebACLForResource",
#                 "waf-regional:AssociateWebACL",
#                 "waf-regional:DisassociateWebACL",
#                 "wafv2:GetWebACL",
#                 "wafv2:GetWebACLForResource",
#                 "wafv2:AssociateWebACL",
#                 "wafv2:DisassociateWebACL",
#                 "shield:GetSubscriptionState",
#                 "shield:DescribeProtection",
#                 "shield:CreateProtection",
#                 "shield:DeleteProtection"
#             ],
#             "Resource": "*"
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "ec2:AuthorizeSecurityGroupIngress",
#                 "ec2:RevokeSecurityGroupIngress"
#             ],
#             "Resource": "*"
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "ec2:CreateSecurityGroup"
#             ],
#             "Resource": "*"
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "ec2:CreateTags"
#             ],
#             "Resource": "arn:aws:ec2:*:*:security-group/*",
#             "Condition": {
#                 "StringEquals": {
#                     "ec2:CreateAction": "CreateSecurityGroup"
#                 },
#                 "Null": {
#                     "aws:RequestTag/elbv2.k8s.aws/cluster": "false"
#                 }
#             }
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "ec2:CreateTags",
#                 "ec2:DeleteTags"
#             ],
#             "Resource": "arn:aws:ec2:*:*:security-group/*",
#             "Condition": {
#                 "Null": {
#                     "aws:RequestTag/elbv2.k8s.aws/cluster": "true",
#                     "aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
#                 }
#             }
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "ec2:AuthorizeSecurityGroupIngress",
#                 "ec2:RevokeSecurityGroupIngress",
#                 "ec2:DeleteSecurityGroup"
#             ],
#             "Resource": "*",
#             "Condition": {
#                 "Null": {
#                     "aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
#                 }
#             }
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "elasticloadbalancing:CreateLoadBalancer",
#                 "elasticloadbalancing:CreateTargetGroup"
#             ],
#             "Resource": "*",
#             "Condition": {
#                 "Null": {
#                     "aws:RequestTag/elbv2.k8s.aws/cluster": "false"
#                 }
#             }
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "elasticloadbalancing:CreateListener",
#                 "elasticloadbalancing:DeleteListener",
#                 "elasticloadbalancing:CreateRule",
#                 "elasticloadbalancing:DeleteRule"
#             ],
#             "Resource": "*"
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "elasticloadbalancing:AddTags",
#                 "elasticloadbalancing:RemoveTags"
#             ],
#             "Resource": [
#                 "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
#                 "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
#                 "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*"
#             ],
#             "Condition": {
#                 "Null": {
#                     "aws:RequestTag/elbv2.k8s.aws/cluster": "true",
#                     "aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
#                 }
#             }
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "elasticloadbalancing:AddTags",
#                 "elasticloadbalancing:RemoveTags"
#             ],
#             "Resource": [
#                 "arn:aws:elasticloadbalancing:*:*:listener/net/*/*/*",
#                 "arn:aws:elasticloadbalancing:*:*:listener/app/*/*/*",
#                 "arn:aws:elasticloadbalancing:*:*:listener-rule/net/*/*/*",
#                 "arn:aws:elasticloadbalancing:*:*:listener-rule/app/*/*/*"
#             ]
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "elasticloadbalancing:ModifyLoadBalancerAttributes",
#                 "elasticloadbalancing:SetIpAddressType",
#                 "elasticloadbalancing:SetSecurityGroups",
#                 "elasticloadbalancing:SetSubnets",
#                 "elasticloadbalancing:DeleteLoadBalancer",
#                 "elasticloadbalancing:ModifyTargetGroup",
#                 "elasticloadbalancing:ModifyTargetGroupAttributes",
#                 "elasticloadbalancing:DeleteTargetGroup",
#                 "elasticloadbalancing:ModifyListenerAttributes",
#                 "elasticloadbalancing:ModifyCapacityReservation",
#                 "elasticloadbalancing:ModifyIpPools"
#             ],
#             "Resource": "*",
#             "Condition": {
#                 "Null": {
#                     "aws:ResourceTag/elbv2.k8s.aws/cluster": "false"
#                 }
#             }
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "elasticloadbalancing:AddTags"
#             ],
#             "Resource": [
#                 "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
#                 "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
#                 "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*"
#             ],
#             "Condition": {
#                 "StringEquals": {
#                     "elasticloadbalancing:CreateAction": [
#                         "CreateTargetGroup",
#                         "CreateLoadBalancer"
#                     ]
#                 },
#                 "Null": {
#                     "aws:RequestTag/elbv2.k8s.aws/cluster": "false"
#                 }
#             }
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "elasticloadbalancing:RegisterTargets",
#                 "elasticloadbalancing:DeregisterTargets"
#             ],
#             "Resource": "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*"
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "elasticloadbalancing:SetWebAcl",
#                 "elasticloadbalancing:ModifyListener",
#                 "elasticloadbalancing:AddListenerCertificates",
#                 "elasticloadbalancing:RemoveListenerCertificates",
#                 "elasticloadbalancing:ModifyRule",
#                 "elasticloadbalancing:SetRulePriorities"
#             ],
#             "Resource": "*"
#         }
#     ]
#   })
# }
# resource "aws_eks_pod_identity_association" "alb_ingress_controller" {
#   cluster_name    = aws_eks_cluster.example.name
#   namespace       = "kube-system"
#   service_account = "aws-ingress-aws-load-balancer-controller"
#   role_arn        = aws_iam_role.aws_alb_controller_role.arn
# }