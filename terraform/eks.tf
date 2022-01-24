# Cluster configuration with roles attached and VPC specified
resource "aws_eks_cluster" "kubik" {
  name     = var.kubik_cluster_name
  role_arn = aws_iam_role.kubik-cluster.arn

  kubernetes_network_config {
    service_ipv4_cidr = "192.168.0.0/24"
  }

  vpc_config {
    security_group_ids      = [aws_security_group.kubik-cluster.id]
    subnet_ids              = aws_subnet.kubik[*].id
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  depends_on = [
    aws_iam_role_policy_attachment.kubik-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.kubik-cluster-AmazonEKSVPCResourceController,
  ]
  tags = {
    Name  = var.eks_tags[0],
    Owner = var.eks_tags[1]
  }
}

# Node configuration with IAM roles attached & auto scaling specified
resource "aws_eks_node_group" "kubik" {
  cluster_name    = aws_eks_cluster.kubik.name
  node_group_name = "kubik"
  node_role_arn   = aws_iam_role.kubik-node.arn
  subnet_ids      = aws_subnet.kubik[*].id

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.kubik-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.kubik-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.kubik-node-AmazonEC2ContainerRegistryReadOnly,
  ]
  tags = {
    Name  = var.eks_tags[0],
    Owner = var.eks_tags[1]
  }
}
