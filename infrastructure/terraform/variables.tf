# VPC
variable "vpc_name" {}
variable "vpc_cidr_block" {}
variable "public_subnets" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}
variable "availability_zones" {
  type = list(string)
}

# EKS
variable "cluster_name" {}
variable "cluster_role_arn" {}
variable "node_role_arn" {}

# RDS
variable "db_identifier" {}
variable "db_name" {}
variable "db_username" {}
variable "db_password" {
  sensitive = true
}
#variable "db_security_group_id" {}

# S3
variable "bucket_name" {}

# IAM
variable "irsa_role_name" {}
variable "oidc_provider_arn" {}
variable "oidc_provider_url" {}
variable "k8s_namespace" {}
variable "service_account_name" {}
