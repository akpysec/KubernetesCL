variable "vpc_tags" {
  type    = list(string)
  default = ["SUNNY-VPC", "AKpySec"]
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
  type    = string
}

variable "subnet_cidrs" {
  default     = ["10.0.100.0/24", "10.0.101.0/24"]
  type        = list(string)
  description = "DB & K8s Subnets"
}

variable "db_tags" {
  type    = list(string)
  default = ["SUNNY-DB", "AKpySec"]
}

variable "eks_tags" {
  type    = list(string)
  default = ["SUNNY-K8s", "AKpySec"]
}

variable "sg_tags" {
  type    = list(string)
  default = ["SUNNY-DB-SG", "AKpySec"]
}

variable "sunny_cluster_name" {
  type    = string
  default = "sunny-eks"
}