# Setting a Provider information and authentication profile
provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/home/ec2-user/.aws/credentials"
  profile                 = "default"
}

provider "http" {}

terraform {
  backend "s3" {
    bucket = "sunbit-interview"
    key    = "environment/terraform.tfstate"
    region = "us-east-1"
  }
}

