variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "cluster_role_arn" {
  type        = string
  description = "IAM role ARN for EKS cluster"
}

variable "node_role_arn" {
  type        = string
  description = "IAM role ARN for EKS node group"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for EKS (public or private)"
}
