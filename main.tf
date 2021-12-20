# Setting a Provider information and authentication profile
provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/home/ec2-user/.aws/credentials"
  profile                 = "default"
}

# Configure the MySQL provider based on the outcome of
# creating the aws_db_instance.
##### Error #####
# provider "mysql" {
#   endpoint = aws_db_instance.sunny_db.endpoint
#   username = aws_db_instance.sunny_db.username
#   password = aws_db_instance.sunny_db.password
# }

provider "http" {}

terraform {
  backend "s3" {
    bucket = "sunbit-interview"
    key    = "environment/terraform.tfstate"
    region = "us-east-1"
  }
}

