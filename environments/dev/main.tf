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


resource "aws_secretsmanager_secret" "app" {
  name                    = "terraform-production/dev/app"
  description             = "Temporary Infra2Agent lab secret metadata"
  recovery_window_in_days = 0

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = var.managed_by
    Purpose     = "LearningLab"
  }
}

resource "aws_iam_policy" "secret_reader" {
  name        = "terraform-production-dev-secret-reader"
  description = "Allow reading one specific lab secret"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ReadSpecificLabSecret"
        Effect = "Allow"
        Action = [
          "secretsmanager:DescribeSecret",
          "secretsmanager:GetSecretValue"
        ]
        Resource = aws_secretsmanager_secret.app.arn
      }
    ]
  })

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = var.managed_by
    Purpose     = "LearningLab"
  }
}

resource "aws_iam_role" "app_reader" {
  name = "terraform-production-dev-app-reader"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = var.managed_by
    Purpose     = "LearningLab"
  }
}

resource "aws_iam_role_policy_attachment" "secret_reader" {
  role       = aws_iam_role.app_reader.name
  policy_arn = aws_iam_policy.secret_reader.arn
}
