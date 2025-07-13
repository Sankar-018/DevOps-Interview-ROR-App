# Create IAM role for EKS pods (IRSA)
resource "aws_iam_role" "irsa_role" {
  name = var.irsa_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = var.oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${var.oidc_provider_url}:sub" = "system:serviceaccount:${var.k8s_namespace}:${var.service_account_name}"
          }
        }
      }
    ]
  })
}

# Attach S3 policy (from S3 module) to the IRSA role
resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.irsa_role.name
  policy_arn = var.s3_policy_arn
}
