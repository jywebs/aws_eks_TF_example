variable "cluster_role_name" {
  type    = string
  default = "eks-cluster-role"
}

variable "node_role_name" {
  type    = string
  default = "eks-node-role"
}

variable "eks_service_principal" {
  type    = string
  default = "eks.amazonaws.com"
}

variable "ec2_service_principal" {
  type    = string
  default = "ec2.amazonaws.com"
}