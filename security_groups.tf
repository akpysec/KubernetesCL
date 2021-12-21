# RDS - MySQL Security Group
resource "aws_security_group" "db_sg" {
  name        = "to_DB"
  description = "Allow inbound traffic from EKS"
  vpc_id      = aws_vpc.sunny_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/0", "10.0.2.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = var.sg_tags[0]
    Owner = var.sg_tags[1]
  }
}

# EKS - Security Group allowing communication with worker node
resource "aws_security_group" "sunny-cluster" {
  name        = "terraform-eks-sunny-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.sunny_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = var.sunny_cluster_name
    Owner = var.vpc_tags[1]
  }
}

