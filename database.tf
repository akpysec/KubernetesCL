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
  tags = {
    Name  = var.db_tags[0]
    Owner = var.db_tags[1]
  }
}

# resource "mysql_database" "app" {
#   count = length(var.db_list)
#   name  = element(var.db_list, count.index)
# }

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = aws_subnet.rds_subnet_.*.id
}
