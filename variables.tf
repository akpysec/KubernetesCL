variable "vpc_tags" {
  type    = list(string)
  default = ["SUNNY-VPC", "AKpySec"]
}

variable "vpc_cidr" {
  default = "172.16.0.0/16"
  type    = string
}

variable "db_subnet_cidrs" {
  default     = ["172.16.100.0/24", "172.16.101.0/24"]
  type        = list(string)
  description = "DB Subnets"
}

variable "eks_subnet_cidrs" {
  default     = ["172.16.200.0/24", "172.16.201.0/24"]
  type        = list(string)
  description = "K8s Subnets"
}

variable "db_tags" {
  type    = list(string)
  default = ["SUNNY-DB", "AKpySec", "sunny-mysql"]
}

variable "eks_tags" {
  type    = list(string)
  default = ["SUNNY-K8s", "AKpySec"]
}

variable "sunny_cluster_name" {
  type    = string
  default = "SUNNY-EKS"
}

variable "user_list" {
  type    = list(string)
  default = ["Omri", "Oran", "Shay", "Igor"]
}

variable "db_list" {
  type    = list(string)
  default = ["Prod", "Test", "Stage", "Dev"]
}

# Update those variables to match your VPC
variable "cloud9_vpc_id" {
  description = "Enter your Cloud9 VPC ID"
  type    = string
  #  default = "HARDCODE_VALUE"
}

variable "cloud9_subnet" {
  type    = string
  description = "Enter subnet where your Cloud9 Instance is hosted"
#  default = "HARDCODE_VALUE"
}

variable "cloud9_route_table_id" {
  type    = string
  description = "Enter your Cloud9 Route Table ID, so that a routes would be added"
  #  default = "HARDCODE_VALUE"
}
