variable "irsa_role_name" {
  type        = string
  description = "Name for the IAM role to be used by EKS pods (IRSA)"
}

variable "oidc_provider_arn" {
  type        = string
  description = "OIDC provider ARN from EKS cluster"
}

variable "oidc_provider_url" {
  type        = string
  description = "OIDC provider URL (without https://)"
}

variable "s3_policy_arn" {
  type        = string
  description = "ARN of the IAM policy to access S3 (from s3 module)"
}

variable "k8s_namespace" {
  type        = string
  description = "Kubernetes namespace where the app runs"
}

variable "service_account_name" {
  type        = string
  description = "ServiceAccount name used in the Kubernetes deployment"
}
