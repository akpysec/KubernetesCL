# MySQL in RDS
resource "aws_db_instance" "sunny_db" {
  identifier             = "sunny-mysql"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  instance_class         = "db.t2.micro"
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  name                   = "SunnyDB"
  username               = "sun_admin"
  password               = data.aws_ssm_parameter.rds_password.value
  vpc_security_group_ids = [aws_security_group.db_sg.id]

}

# resource "mysql_database" "app" {
#   count = length(var.db_list)
#   name  = element(var.db_list, count.index)
# }

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = aws_subnet.rds_subnet_.*.id
}

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
