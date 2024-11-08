resource "aws_iam_role" "eks-cluster-role" {
  name = format("%s-eks-cluster-role", var.cluster_name)
  tags = {
    Name       = format("%s-cluster", var.cluster_name)
    created_by = var.created_by
  }

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster-role.name
}

resource "aws_eks_cluster" "cluster_quickops" {
  name     = var.cluster_name
  version  = var.EKS_Kubernetes_Version
  role_arn = aws_iam_role.eks-cluster-role.arn

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }
  vpc_config {
    subnet_ids = [
      var.subnet_id_private_1,
      var.subnet_id_private_2
    ]

  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
  tags = {
    Name       = format("%s-cluster", var.cluster_name)
    created_by = var.created_by
  }
}