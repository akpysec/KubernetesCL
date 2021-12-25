# Creating a VPC, Tagging with given name for the environment
resource "aws_vpc" "sunny_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name  = var.vpc_tags[0]
    Owner = var.vpc_tags[1]
  }
}

# Creating RDS SUBNETS in a -> SunnyVPC (AZ-1-2) ^
resource "aws_subnet" "rds_subnet_" {
  count             = 2
  vpc_id            = aws_vpc.sunny_vpc.id
  cidr_block        = var.db_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name  = var.db_tags[0]
    Owner = var.db_tags[1]
  }
}

# Cloud9 to Sunny VPC peering
resource "aws_vpc_peering_connection" "cloud9_to_sunny_vpc" {
  peer_vpc_id = aws_vpc.sunny_vpc.id
  vpc_id      = var.cloud9_vpc_id
  auto_accept = true

  tags = {
    Name = "VPC Peering between Cloud9 and Sunny"
  }
}

# Adding additional route back to Cloud9 environment
resource "aws_route_table" "sunny_db" {
  vpc_id = aws_vpc.sunny_vpc.id

  # For VPC Peering between Sunny VPC & Cloud9 VPC
  route {
    cidr_block = var.cloud9_subnet
    gateway_id = aws_vpc_peering_connection.cloud9_to_sunny_vpc.id
  }

  tags = {
    Name  = var.db_tags[0]
    Owner = var.db_tags[1]
  }
}

resource "aws_route_table_association" "sunny_db" {
  count          = 2
  subnet_id      = aws_subnet.rds_subnet_.*.id[count.index]
  route_table_id = aws_route_table.sunny_db.id
}

# Adding Route from Cloud9 subnet to DB subnets
resource "aws_route" "cloud9_subnet_to_db_subnets" {
  count                     = length(var.db_subnet_cidrs)
  route_table_id            = var.cloud9_route_table_id
  destination_cidr_block    = var.db_subnet_cidrs[count.index]
  vpc_peering_connection_id = aws_vpc_peering_connection.cloud9_to_sunny_vpc.id
  depends_on                = [aws_route_table.sunny]
}

# EKS Infrastracture
resource "aws_subnet" "sunny" {
  count                   = 2
  vpc_id                  = aws_vpc.sunny_vpc.id
  cidr_block              = var.eks_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true


  tags = {
    Name  = var.eks_tags[0]
    Owner = var.eks_tags[1]

  }
}

resource "aws_internet_gateway" "sunny" {
  vpc_id = aws_vpc.sunny_vpc.id

  tags = {
    Name  = var.eks_tags[0],
    Owner = var.eks_tags[1]
  }
}

resource "aws_route_table" "sunny" {
  vpc_id = aws_vpc.sunny_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sunny.id
  }

  tags = {
    Name  = var.eks_tags[0],
    Owner = var.eks_tags[1]
  }
}

resource "aws_route_table_association" "sunny" {
  count          = 2
  subnet_id      = aws_subnet.sunny.*.id[count.index]
  route_table_id = aws_route_table.sunny.id
}
