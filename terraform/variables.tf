variable "vpc_tags" {
  type    = list(string)
  default = ["kubik-VPC", "AKpySec"]
}

variable "vpc_cidr" {
  default = "172.16.0.0/16"
  type    = string
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

variable "eks_tags" {
  type    = list(string)
  default = ["kubik-EKS", "AKpySec"]
}

variable "kubik_cluster_name" {
  type    = string
  default = "kubik-EKS"
}

# Getting Cloud9 Instance Local IP
locals {
  local_ip = "${chomp(data.http.local_ip.body)}/32"
}

# Update those variables to match your VPC
variable "cloud9_vpc_id" {
  type    = string
  default = "vpc-06dec4bd7ac56d988"
}

variable "cloud9_route_table_id" {
  type    = string
  default = "rtb-0ea83e644aa7ab3d3"
}
