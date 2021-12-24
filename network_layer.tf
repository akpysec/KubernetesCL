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
  count = 2

  vpc_id            = aws_vpc.sunny_vpc.id
  cidr_block        = var.subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name  = var.db_tags[0]
    Owner = var.db_tags[1]
  }
}

# Adding additional route back to Cloud9 environment
resource "aws_route_table" "sunny_db" {
  vpc_id = aws_vpc.sunny_vpc.id

  # For VPC Peering between Sunny VPC & Cloud9 VPC
  route {
    cidr_block = var.cloud9_vpc_cidr
    gateway_id = aws_vpc_peering_connection.cloud9_to_sunny_vpc.id
  }

  tags = {
    Name  = var.db_tags[0]
    Owner = var.db_tags[1]
  }
}

resource "aws_route_table_association" "sunny_db" {
  count = 2

  subnet_id      = aws_subnet.rds_subnet_.*.id[count.index]
  route_table_id = aws_route_table.sunny_db.id
}


# EKS Infrastracture
resource "aws_subnet" "sunny" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "172.16.20${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.sunny_vpc.id

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
  count = 2

  subnet_id      = aws_subnet.sunny.*.id[count.index]
  route_table_id = aws_route_table.sunny.id
}

# Cloud9 to Sunny VPC peering
resource "aws_vpc_peering_connection" "cloud9_to_sunny_vpc" {
  peer_vpc_id = var.cloud9_vpc_id
  vpc_id      = aws_vpc.sunny_vpc.id
  auto_accept = true

  tags = {
    Name = "VPC Peering between Cloud9 and Sunny"
  }
}

