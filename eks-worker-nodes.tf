# Creating Role for EKS Node
resource "aws_iam_role" "sunny-node" {
  name = "terraform-eks-sunny-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Attaching Policies to a EKS Node Role
resource "aws_iam_role_policy_attachment" "sunny-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.sunny-node.name
}

resource "aws_iam_role_policy_attachment" "sunny-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.sunny-node.name
}

resource "aws_iam_role_policy_attachment" "sunny-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.sunny-node.name
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
}