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
  type    = string
  default = "<UPDATE FIELD>" 
}

variable "cloud9_subnet" {
  type    = string
  default = "<UPDATE FIELD>" 
#  default = "10.0.0.0/24"
}

variable "cloud9_route_table_id" {
  type    = string
  default = "<UPDATE FIELD>" 
}
