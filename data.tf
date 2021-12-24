# Get Password from SSM Parameter Store
data "aws_ssm_parameter" "rds_password" {
  name       = "/sunny_db/mysql"
  depends_on = [aws_ssm_parameter.rds_password]
}

data "aws_ssm_parameter" "rds_users_passwords" {
  count = length(var.user_list)
  name  = "/sunny_db/${element(var.user_list, count.index)}"
  # name       = "/sunny_db/mysql"
  depends_on = [aws_ssm_parameter.rds_users_passwords]
}
# Getting availability zones list
data "aws_availability_zones" "available" {}


# Checking Public IP of a workstation (Cluster)
data "http" "workstation-external-ip" {
  url = "http://ipv4.icanhazip.com"
}

data "aws_db_instance" "sunny_db" {
  db_instance_identifier = var.db_tags[2]
  depends_on             = [aws_db_instance.sunny_db]
}
