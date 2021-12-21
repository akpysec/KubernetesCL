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
