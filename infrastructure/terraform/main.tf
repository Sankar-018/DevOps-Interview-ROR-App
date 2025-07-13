# VPC Module
module "vpc" {
  source              = "./modules/vpc"
  vpc_name            = var.vpc_name
  cidr_block          = var.vpc_cidr_block
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
  availability_zones  = var.availability_zones
}

# EKS Module
module "eks" {
  source             = "./modules/eks"
  cluster_name       = var.cluster_name
  cluster_role_arn   = var.cluster_role_arn
  node_role_arn      = var.node_role_arn
  subnet_ids         = module.vpc.private_subnet_ids
}

module "rds" {
  source              = "./modules/rds"
  db_identifier       = var.db_identifier
  db_name             = var.db_name
  db_username         = var.db_username
  db_password         = var.db_password
  private_subnet_ids  = module.vpc.private_subnet_ids
  security_group_id   = aws_security_group.rds_sg.id  
}

# S3 Module
module "s3" {
  source       = "./modules/s3"
  bucket_name  = var.bucket_name
}

# IAM Module (IRSA)
module "iam" {
  source                = "./modules/iam"
  irsa_role_name        = var.irsa_role_name
  oidc_provider_arn     = var.oidc_provider_arn
  oidc_provider_url     = var.oidc_provider_url
  k8s_namespace         = var.k8s_namespace
  service_account_name  = var.service_account_name
  s3_policy_arn         = module.s3.s3_access_policy_arn
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-db-sg"
  description = "Allow Postgres access from EKS"
  vpc_id      = module.vpc.vpc_id  # Connects to the Terraform-created VPC

  ingress {
    description = "PostgreSQL access from EKS"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.private_subnets  # Allow from EKS private subnets
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "rds-db-sg"
    Environment = "dev"
    Project     = "DevOpsAssignment"
  }
}
