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

# Creating Databases
resource "mysql_database" "app" {
  count = length(var.db_list)
  name  = element(var.db_list, count.index)
}


resource "mysql_user" "mysql_users" {
  count              = length(var.user_list)
  user               = element(var.user_list, count.index)
  host               = aws_db_instance.sunny_db.address
  tls_option         = "SSL"
  plaintext_password = data.aws_ssm_parameter.rds_users_passwords[count.index].value
}

resource "mysql_grant" "mysql_users_permissions" {
  count      = length(var.user_list)
  user       = element(var.user_list, count.index)
  host       = mysql_user.mysql_users[count.index].host
  database   = aws_db_instance.sunny_db.name
  privileges = ["SELECT"]
}
