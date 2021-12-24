# Ingress rules SG group
resource "aws_security_group_rule" "sunny-cluster-ingress-workstation-https" {
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.sunny-cluster.id
  to_port           = 443
  type              = "ingress"
}

# Cluster configuration with roles attached and VPC specified
resource "aws_eks_cluster" "sunny" {
  name     = var.sunny_cluster_name
  role_arn = aws_iam_role.sunny-cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.sunny-cluster.id]
    subnet_ids         = aws_subnet.sunny[*].id
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

# Override with variable or hardcoded value if necessary
locals {
  workstation-external-cidr = "${chomp(data.http.workstation-external-ip.body)}/32"
}
