# Getting local IP address
data "http" "local_ip" {
  url = "http://169.254.169.254/latest/meta-data/local-ipv4"
}

# Getting availability zones list
data "aws_availability_zones" "available" {}
