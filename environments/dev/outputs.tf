output "bucket_name" {
  description = "Name of the dev application S3 bucket"
  value       = module.app_bucket.bucket_name
}

output "bucket_arn" {
  description = "ARN of the dev application S3 bucket"
  value       = module.app_bucket.bucket_arn
}


output "vpc_id" {
  description = "ID of the Dev VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "CIDR range of the Dev VPC"
  value       = module.vpc.vpc_cidr
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "IDs of the private application subnets"
  value       = module.vpc.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "IDs of the private database subnets"
  value       = module.vpc.private_db_subnet_ids
}
