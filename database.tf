# MySQL in RDS
resource "aws_db_instance" "sunny_db" {
  identifier                          = var.db_tags[2]
  allocated_storage                   = 20
  storage_type                        = "gp2"
  engine                              = "mysql"
  instance_class                      = "db.t2.micro"
  db_subnet_group_name                = aws_db_subnet_group.db_subnet_group.name
  name                                = "SunnyDB"
  username                            = "sun_admin"
  password                            = data.aws_ssm_parameter.rds_password.value
  iam_database_authentication_enabled = true
  vpc_security_group_ids              = [aws_security_group.db_sg.id]
  skip_final_snapshot                 = true

  tags = {
    Name  = var.db_tags[0]
    Owner = var.db_tags[1]
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = aws_subnet.rds_subnet_.*.id
}

# # Creating Databases
# resource "mysql_database" "app" {
#   count = length(var.db_list)
#   name  = element(var.db_list, count.index)
# }

# Every time the same error - Unresolved , yet
# | 2021-12-23T19:22:26.585Z [ERROR] vertex "mysql_database.app" error: Could not connect to server: dial tcp 10.0.100.215:3306: connect: connection timed out
# |
# │ Error: Could not connect to server: dial tcp 10.0.100.215:3306: connect: connection timed out
# │ 
# │   with mysql_database.app,
# │   on database.tf line 28, in resource "mysql_database" "app":
# │   28: resource "mysql_database" "app" {
# │ 
# ╵


