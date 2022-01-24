# Setting a Provider information and authentication profile
provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/home/ec2-user/.aws/credentials"
  profile                 = "default"
}

terraform {

  backend "s3" {
    bucket = "kubernetes-akpysec"
    key    = "environment/terraform.tfstate"
    region = "us-east-1"
  }

  required_providers {

    http = {
      source  = "hashicorp/http"
      version = "2.1.0"
    }

  }
}
