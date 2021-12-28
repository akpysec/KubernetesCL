# Generate Master Password
resource "random_string" "rds_master_password" {
  length           = 16
  special          = true
  override_special = "@#$%^*()-=_+[]{};<>?,./"
}

# Store Master Password in SSM Parameter Store
resource "aws_ssm_parameter" "rds_master_password" {
  name        = "/sunny_db/mysql_master"
  description = "Master Password for MySQL in RDS"
  type        = "SecureString"
  value       = random_string.rds_master_password.result
  tags = {
    Name  = var.db_tags[0]
    Owner = var.db_tags[1]
  }
}

# Generate Users Passwords
resource "random_string" "rds_users_passwords" {
  count            = length(var.user_list)
  length           = 16
  special          = true
  override_special = "@#$%^*()-=_+[]{};<>?,./"
}

# Store Users Passwords in SSM Parameter Store
resource "aws_ssm_parameter" "rds_users_passwords" {
  count       = length(var.user_list)
  name        = "/sunny_db/${element(var.user_list, count.index)}"
  description = "Users Password for MySQL in RDS"
  type        = "SecureString"
  value       = random_string.rds_users_passwords[count.index].result
  tags = {
    Name  = var.db_tags[0]
    Owner = var.db_tags[1]
  }
}

