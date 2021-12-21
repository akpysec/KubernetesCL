# Generate Password
resource "random_string" "rds_password" {
  length  = 12
  special = true
}

# Store Password in SSM Parameter Store
resource "aws_ssm_parameter" "rds_password" {
  name        = "/sunny_db/mysql"
  description = "Master Password for MySQL in RDS"
  type        = "SecureString"
  value       = random_string.rds_password.result
}

