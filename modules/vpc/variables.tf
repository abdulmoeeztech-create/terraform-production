
variable "name_prefix" {
  description = "Prefix used to name VPC resources"
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR range for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "Availability Zones for the network"
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "This module currently expects exactly two Availability Zones."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR ranges for public subnets, one per AZ"
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Provide exactly two public subnet CIDRs."
  }
}

variable "private_app_subnet_cidrs" {
  description = "CIDR ranges for private application subnets, one per AZ"
  type        = list(string)

  validation {
    condition     = length(var.private_app_subnet_cidrs) == 2
    error_message = "Provide exactly two private application subnet CIDRs."
  }
}

variable "private_db_subnet_cidrs" {
  description = "CIDR ranges for isolated database subnets, one per AZ"
  type        = list(string)

  validation {
    condition     = length(var.private_db_subnet_cidrs) == 2
    error_message = "Provide exactly two private database subnet CIDRs."
  }
}

variable "tags" {
  description = "Common tags applied to VPC resources"
  type        = map(string)
  default     = {}
}
