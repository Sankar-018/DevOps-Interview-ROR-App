########################################
# EKS Outputs
########################################
output "eks_cluster_name" {
  description = "Name of the EKS Cluster"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "API endpoint of the EKS Cluster"
  value       = module.eks.cluster_endpoint
}

output "kubeconfig_ca_data" {
  description = "Certificate authority data for EKS (used in kubeconfig)"
  value       = module.eks.kubeconfig_certificate_authority
}


########################################
# RDS Outputs
########################################
output "rds_endpoint" {
  description = "Connection endpoint for the RDS PostgreSQL instance"
  value       = module.rds.rds_endpoint
}

output "rds_db_name" {
  description = "Database name used in the RDS instance"
  value       = module.rds.db_name
}


########################################
# S3 Outputs
########################################
output "s3_bucket_name" {
  description = "Name of the S3 bucket created"
  value       = module.s3.bucket_name
}


########################################
# IAM / IRSA Outputs
########################################
#output "irsa_role_arn" {
 ##value       = module.iam.irsa_role_arn
#}
