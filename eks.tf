# Cluster configuration with roles attached and VPC specified
resource "aws_eks_cluster" "sunny" {
  name     = var.sunny_cluster_name
  role_arn = aws_iam_role.sunny-cluster.arn

  kubernetes_network_config {
    service_ipv4_cidr = "192.168.0.0/24"
  }

  vpc_config {
    security_group_ids      = [aws_security_group.sunny-cluster.id]
    subnet_ids              = aws_subnet.sunny[*].id
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  depends_on = [
    aws_iam_role_policy_attachment.sunny-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.sunny-cluster-AmazonEKSVPCResourceController,
  ]
  tags = {
    Name  = var.eks_tags[0],
    Owner = var.eks_tags[1]
  }
}

# Node configuration with IAM roles attached & auto scaling specified
resource "aws_eks_node_group" "sunny" {
  cluster_name    = aws_eks_cluster.sunny.name
  node_group_name = "sunny"
  node_role_arn   = aws_iam_role.sunny-node.arn
  subnet_ids      = aws_subnet.sunny[*].id

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.sunny-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.sunny-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.sunny-node-AmazonEC2ContainerRegistryReadOnly,
  ]
  tags = {
    Name  = var.eks_tags[0],
    Owner = var.eks_tags[1]
  }
}
