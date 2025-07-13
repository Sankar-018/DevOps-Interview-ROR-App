output "bucket_name" {
  value = aws_s3_bucket.app_bucket.bucket
}

output "s3_access_policy_arn" {
  value = aws_iam_policy.s3_access_policy.arn
}
