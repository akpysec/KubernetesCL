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
}

# Override with variable or hardcoded value if necessary
locals {
  workstation-external-cidr = "${chomp(data.http.workstation-external-ip.body)}/32"
}
