variable "cluster_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

variable "k8s_version" {
  type    = string
  default = "1.26"
}

variable "node_desired_capacity" {
  type    = number
  default = 2
}

variable "node_max_capacity" {
  type    = number
  default = 3
}

variable "node_min_capacity" {
  type    = number
  default = 1
}

variable "instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}
