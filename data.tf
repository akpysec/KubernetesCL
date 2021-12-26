# Get Master Password from SSM Parameter Store 
data "aws_ssm_parameter" "rds_master_password" {
  name       = "/sunny_db/mysql_master"
  depends_on = [aws_ssm_parameter.rds_master_password]
}

# Get Users Passwords from SSM Parameter Store 
data "aws_ssm_parameter" "rds_users_passwords" {
  count      = length(var.user_list)
  name       = "/sunny_db/${element(var.user_list, count.index)}"
  depends_on = [aws_ssm_parameter.rds_users_passwords]
}

# Getting availability zones list
data "aws_availability_zones" "available" {}


data "aws_db_instance" "sunny_db" {
  db_instance_identifier = var.db_tags[2]
  depends_on             = [aws_db_instance.sunny_db]
}
