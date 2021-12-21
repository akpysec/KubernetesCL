# Users
resource "aws_iam_user" "mysql_users" {
  count = length(var.user_list)
  name  = element(var.user_list, count.index)
}

resource "aws_iam_user_policy_attachment" "mysql_users_policy" {
  count      = length(var.user_list)
  user       = element(aws_iam_user.mysql_users.*.name, count.index)
  policy_arn = aws_iam_policy.policy_mysql_users.arn
}

resource "aws_iam_policy" "policy_mysql_users" {
  name   = "rds-select-statement-only"
  policy = data.aws_iam_policy_document.policy_json.json
}

data "aws_iam_policy_document" "policy_json" {
  statement {
    actions = [
    "rds-data:ExecuteStatement/select*"
    ]
    resources = [
    "*"]
  }
}

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

# Creating Role for EKS Cluster
resource "aws_iam_role" "sunny-cluster" {
  name = "terraform-eks-sunny-cluster"

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

# Attaching Policies to a EKS Cluster Role
resource "aws_iam_role_policy_attachment" "sunny-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.sunny-cluster.name
}

resource "aws_iam_role_policy_attachment" "sunny-cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.sunny-cluster.name
}

