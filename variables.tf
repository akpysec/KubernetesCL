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

variable "eks_to_node_ports" {
  default     = [443, 10250, 53]
  type        = list(number)
  description = "Cluster to Node minimum port restriction"
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

variable "cloud9_route_table_id" {
  type    = string
  description = "Enter your Cloud9 Route Table ID, so that a routes back would be added for the purpose of VPC peering"
  #  default = "HARDCODE_VALUE"
}

# Setting up Cloud9 network with CIDR
variable "cloud9_subnet" {
  type = string
  description = "Enter subnet where Cloud9 Instance is hosted (as such 10.0.0.0/24)"
  #  default = "HARDCODE_VALUE"
}

