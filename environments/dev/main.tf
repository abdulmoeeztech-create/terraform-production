terraform {
  backend "s3" {
    bucket       = "moeez-terraform-state-lab"
    key          = "environments/dev/terraform.tfstate"
    region       = "ap-south-1"
    profile      = "terraform-sandbox"
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "ap-south-1"
  profile = "terraform-sandbox"
}


module "app_bucket" {
  source = "../../modules/s3"

  bucket_name = var.bucket_name

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = var.managed_by
  }
}
