# Creating a VPC, Tagging with given name for the environment
resource "aws_vpc" "kubik_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name  = var.vpc_tags[0]
    Owner = var.vpc_tags[1]
  }
}

# Cloud9 to kubik VPC peering
resource "aws_vpc_peering_connection" "cloud9_to_kubik_vpc" {
  peer_vpc_id = aws_vpc.kubik_vpc.id
  vpc_id      = var.cloud9_vpc_id
  auto_accept = true

  tags = {
    Name = "VPC Peering between Cloud9 and kubik"
  }
}

# Adding additional route back to Cloud9 environment
resource "aws_route_table" "kubik_route" {
  vpc_id = aws_vpc.kubik_vpc.id

  # For VPC Peering between kubik VPC & Cloud9 VPC
  route {
    cidr_block = local.local_ip
    gateway_id = aws_vpc_peering_connection.cloud9_to_kubik_vpc.id
  }

  tags = {
    Name  = var.eks_tags[0]
    Owner = var.eks_tags[1]
  }
}

# Adding Route from Cloud9 subnet to EKS subnets
resource "aws_route" "cloud9_subnet_to_eks_subnets" {
  count                     = length(var.eks_subnet_cidrs)
  route_table_id            = var.cloud9_route_table_id
  destination_cidr_block    = var.eks_subnet_cidrs[count.index]
  vpc_peering_connection_id = aws_vpc_peering_connection.cloud9_to_kubik_vpc.id
}

# EKS Infrastracture
resource "aws_subnet" "kubik" {
  count                   = 2
  vpc_id                  = aws_vpc.kubik_vpc.id
  cidr_block              = var.eks_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name  = var.eks_tags[0]
    Owner = var.eks_tags[1]

  }
}

resource "aws_route_table" "kubik" {
  vpc_id = aws_vpc.kubik_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kubik.id
  }

  route {
    cidr_block = local.local_ip
    gateway_id = aws_vpc_peering_connection.cloud9_to_kubik_vpc.id
  }

  tags = {
    Name  = var.eks_tags[0],
    Owner = var.eks_tags[1]
  }
}

resource "aws_route_table_association" "kubik" {
  count          = 2
  subnet_id      = aws_subnet.kubik.*.id[count.index]
  route_table_id = aws_route_table.kubik.id
}

resource "aws_internet_gateway" "kubik" {
  vpc_id = aws_vpc.kubik_vpc.id

  tags = {
    Name  = var.eks_tags[0],
    Owner = var.eks_tags[1]
  }
}
