# RDS - MySQL Security Group
resource "aws_security_group" "db_sg" {
  name        = "to_DB"
  description = "Allow inbound traffic from EKS"
  vpc_id      = aws_vpc.sunny_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.eks_subnet_cidrs[0], var.eks_subnet_cidrs[1], var.cloud9_subnet]
  }

  tags = {
    Name  = var.db_tags[0]
    Owner = var.db_tags[1]
  }
}

# EKS - Security Group allowing communication with worker node
resource "aws_security_group" "sunny-cluster" {
  name        = "terraform-eks-sunny-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.sunny_vpc.id

  dynamic "egress" {
    for_each = var.eks_to_node_ports
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = [var.eks_subnet_cidrs[0], var.eks_subnet_cidrs[1]]
    }
  }

  tags = {
    Name  = var.eks_tags[0],
    Owner = var.eks_tags[1]
  }
}

# Ingress rules SG group
resource "aws_security_group_rule" "sunny-cluster-ingress-workstation-https" {
  cidr_blocks       = [var.cloud9_subnet]
  description       = "Allow Cloud9 Instance to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.sunny-cluster.id
  to_port           = 443
  type              = "ingress"
}
