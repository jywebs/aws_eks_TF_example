variable "cluster_name" {
  type    = string
  default = "eks-cluster"
}

variable "region" {
  type    = string
  default = "us-west-2"
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "node_group_name" {
  type    = string
  default = "eks-managed-ng"
}

variable "desired_capacity" {
  type    = number
  default = 3
}

variable "min_size" {
  type    = number
  default = 2
}

variable "max_size" {
  type    = number
  default = 5
}

variable "instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "eks_version" {
  type    = string
  default = "1.29"
}

variable "cluster_role_arn" {
  type = string
}

variable "node_role_arn" {
  type = string
}