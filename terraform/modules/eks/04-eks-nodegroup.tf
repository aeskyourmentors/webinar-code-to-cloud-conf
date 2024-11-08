resource "aws_iam_role" "worker_node_group_role" {
  name = format("%s-eks-node-group-role", var.cluster_name)
  tags = {
    Name       = format("%s-cluster", var.cluster_name)
    created_by = var.created_by
  }
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
}

resource "aws_iam_role_policy_attachment" "nodes_amazon_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker_node_group_role.name
  depends_on = [aws_iam_role.worker_node_group_role]
}

resource "aws_iam_role_policy_attachment" "nodes_amazon_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.worker_node_group_role.name
  depends_on = [aws_iam_role.worker_node_group_role]
}

resource "aws_iam_role_policy_attachment" "nodes_amazon_ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker_node_group_role.name
  depends_on = [aws_iam_role.worker_node_group_role]
}

#Private ng
resource "aws_eks_node_group" "private_nodegroup_1" {
  cluster_name    = aws_eks_cluster.cluster_quickops.name
  node_group_name = format("%s-private-nodegroup-1", var.cluster_name)
  node_role_arn   = aws_iam_role.worker_node_group_role.arn

  subnet_ids = [
    var.subnet_id_private_1,
    var.subnet_id_private_2
  ]

  capacity_type  = var.private_nodegroup_1["capacity_type"]
  instance_types = var.private_nodegroup_1["instance_types"]

  scaling_config {
    desired_size = var.private_nodegroup_1["desired_size"]
    max_size     = var.private_nodegroup_1["max_size"]
    min_size     = var.private_nodegroup_1["min_size"]
  }

  update_config {
    max_unavailable = var.private_nodegroup_1["desired_size"]
  }

  tags = {
    Name       = format("%s-nodegroup", var.cluster_name)
    created_by = var.created_by
  }

  depends_on = [
    aws_iam_role_policy_attachment.nodes_amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.nodes_amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.nodes_amazon_ec2_container_registry_read_only,
    aws_eks_cluster.cluster_quickops
  ]
}