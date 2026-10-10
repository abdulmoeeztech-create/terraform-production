output "bucket_name" {
  description = "Name of the dev application S3 bucket"
  value       = module.app_bucket.bucket_name
}

output "bucket_arn" {
  description = "ARN of the dev application S3 bucket"
  value       = module.app_bucket.bucket_arn
}