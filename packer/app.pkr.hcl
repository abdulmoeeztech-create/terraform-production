
packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1.3"
    }
  }
}

variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "ami_name_prefix" {
  type    = string
  default = "terraform-production-dev-app"
}

source "amazon-ebs" "al2023" {
  region        = var.aws_region
  instance_type = "t3.micro"

  subnet_id                   = "subnet-0c56e6594a5881bb0"
  associate_public_ip_address = true
  ssh_interface               = "public_ip"

  temporary_security_group_source_public_ip = true
  # Keep the AMI private; do not share it with other accounts.

  ami_name        = "${var.ami_name_prefix}-{{timestamp}}"
  ami_description = "Private Amazon Linux 2023 application base image built with Packer"

  source_ami_filter {
    filters = {
      name                = "al2023-ami-2023.*-kernel-*-x86_64"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }

    owners      = ["137112412989"]
    most_recent = true
  }

  ssh_username = "ec2-user"

  ami_virtualization_type = "hvm"
  encrypt_boot            = true
  kms_key_id              = "arn:aws:kms:ap-south-1:624586968963:key/d33b87f8-9966-4581-b15b-0b87acddf4c7"

  tags = {
    Project     = "terraform-production"
    Environment = "dev"
    ManagedBy   = "Packer"
    Purpose     = "LearningLab"
  }

  run_tags = {
    Project     = "terraform-production"
    Environment = "dev"
    ManagedBy   = "Packer"
    Purpose     = "TemporaryImageBuilder"
  }
}

build {
  sources = ["source.amazon-ebs.al2023"]

  provisioner "shell" {
    inline = [
      "sudo dnf install -y httpd",
      "sudo systemctl enable httpd",
      "sudo mkdir -p /var/www/html",
      "echo 'Infra2Agent application is healthy' | sudo tee /var/www/html/index.html",
      "sudo chmod 644 /var/www/html/index.html"
    ]
  }

  post-processors {
    post-processor "manifest" {
      output     = "packer/manifest.json"
      strip_path = true
    }
  }
}
