# Creating Role for EKS Node
resource "aws_iam_role" "sunny-node" {
  name = "terraform-eks-sunny-node"

  assume_role_policy = file("./policies/node_cluster.json")
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

# Creating Role for EKS Cluster
resource "aws_iam_role" "sunny-cluster" {
  name = "terraform-eks-sunny-cluster"

  assume_role_policy = file("./policies/eks_cluster.json")
}

# Attaching Policies to a EKS Cluster Role
resource "aws_iam_role_policy_attachment" "sunny-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.sunny-cluster.name
}

resource "aws_iam_role_policy_attachment" "sunny-cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.sunny-cluster.name
}

