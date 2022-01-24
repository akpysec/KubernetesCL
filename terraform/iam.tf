# Creating Role for EKS Node
resource "aws_iam_role" "kubik-node" {
  name = "terraform-eks-kubik-node"

  assume_role_policy = file("./policies/node_cluster.json")
}

# Attaching Policies to a EKS Node Role
resource "aws_iam_role_policy_attachment" "kubik-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.kubik-node.name
}

resource "aws_iam_role_policy_attachment" "kubik-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.kubik-node.name
}

resource "aws_iam_role_policy_attachment" "kubik-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.kubik-node.name
}

# Creating Role for EKS Cluster
resource "aws_iam_role" "kubik-cluster" {
  name = "terraform-eks-kubik-cluster"

  assume_role_policy = file("./policies/eks_cluster.json")
}

# Attaching Policies to a EKS Cluster Role
resource "aws_iam_role_policy_attachment" "kubik-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.kubik-cluster.name
}

resource "aws_iam_role_policy_attachment" "kubik-cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.kubik-cluster.name
}

