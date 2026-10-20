
variable "bucket_name" {
  description = "Name of the dev application S3 bucket"
  type        = string

  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "The bucket name must contain between 3 and 63 characters."
  }
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "terraform-production"
}

variable "managed_by" {
  description = "Resource management identifier"
  type        = string
  default     = "Terraform"
}

variable "vpc_cidr" {
  description = "CIDR range for the dedicated Dev VPC"
  type        = string
}

variable "availability_zones" {
  description = "Availability Zones for the Dev network"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs for the ALB tier"
  type        = list(string)
}

variable "private_app_subnet_cidrs" {
  description = "Private subnet CIDRs for the application tier"
  type        = list(string)
}

variable "private_db_subnet_cidrs" {
  description = "Private subnet CIDRs for the database tier"
  type        = list(string)
}
