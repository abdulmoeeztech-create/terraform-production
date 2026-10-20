# Production-Style AWS Terraform Infrastructure

A hands-on Infrastructure as Code (IaC) portfolio project demonstrating reusable Terraform modules, remote state management, input validation, AWS Secrets Manager, least-privilege IAM, and secure configuration practices on AWS.

## Project Objectives

- Build reusable Terraform modules for AWS resources.
- Separate environment configuration from reusable infrastructure code.
- Store Terraform state remotely in Amazon S3.
- Use native S3 state locking with Terraform.
- Validate input variables and maintain consistent resource tags.
- Apply least-privilege IAM permissions to AWS resources.
- Explore AWS Secrets Manager integration through Terraform.
- Protect state files and environment-specific configuration from accidental Git commits.

## Architecture

```text
terraform-production/
├── .gitignore
├── README.md
├── environments/
│   └── dev/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── dev.tfvars.example
│       └── .terraform.lock.hcl
└── modules/
    └── s3/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

### Infrastructure Flow

- Terraform uses the AWS provider in `ap-south-1`.
- The dev environment calls a reusable S3 module.
- The application bucket name, environment, project, and management tags are configurable.
- Terraform state is stored in an S3 backend with native S3 state locking enabled.
- AWS Secrets Manager and IAM resources are defined in the dev environment for a least-privilege access lab.

The Terraform backend is managed separately from the application infrastructure repository.

## AWS and Terraform Features

- Amazon S3
- Terraform S3 backend
- Native S3 state locking (`use_lockfile = true`)
- Reusable Terraform modules
- Input variables and validation rules
- Consistent resource tags
- Terraform provider version constraints
- AWS Secrets Manager
- IAM trust policies and managed permissions policies
- Least-privilege access to a specific secret ARN
- Git version control and `.gitignore`

## Application S3 Bucket Security

The reusable S3 module manages the following controls for the application bucket:

- **Bucket versioning:** Enabled to support recovery of previous object versions.
- **Block Public Access:** All four S3 public-access-block settings are enabled.
- **HTTPS-only access:** A bucket policy denies S3 requests made without secure transport (`aws:SecureTransport = false`).
- **Default encryption:** The module explicitly configures server-side encryption using SSE-S3 (`AES256`). AWS was queried to verify the live configuration.

**Cost consideration:** S3 versioning can increase storage costs because previous object versions are retained. Review retention requirements and storage usage before introducing lifecycle expiration rules.

## Security Practices

- Exclude Terraform state files and backups from Git.
- Exclude `.tfvars` files and environment-specific values.
- Commit an example variable template instead of the real dev variables file.
- Use a local AWS CLI profile rather than storing AWS credentials in Terraform code.
- Keep the Terraform state bucket private and protected by appropriate AWS access controls.
- Scope Secrets Manager permissions to the required secret ARN instead of using a wildcard resource.
- Separate an IAM role's trust policy from its permissions policy.
- Use IAM roles and temporary credentials for AWS workloads rather than hard-coded access keys.
- Protect Terraform state because it can contain sensitive values even when CLI output is redacted.

**Important:** `.gitignore` helps prevent accidental commits but does not replace IAM permissions, secret management, or state-backend security controls.

## Secrets Manager and IAM Lab

This lab demonstrates how Terraform can create an AWS Secrets Manager secret container and configure narrowly scoped IAM access.

### Resources

- **AWS Secrets Manager:** Creates a secret metadata container for the development environment. The Terraform configuration does not define a secret value.
- **IAM customer-managed policy:** Grants `secretsmanager:DescribeSecret` and `secretsmanager:GetSecretValue` access to the specific lab secret ARN.
- **IAM role:** Defines a trust relationship allowing the Amazon EC2 service to assume the role.
- **IAM role-policy attachment:** Attaches the managed permissions policy to the IAM role.

### Security and Operational Notes

- The secret is configured with `recovery_window_in_days = 0`, which requests immediate deletion when the resource is destroyed. This setting is intended for the disposable learning lab, not as a default for production secrets.
- No EC2 instance or instance profile is created by this lab.
- The role trust policy and policy attachment were verified using the AWS CLI.
- Actual secret retrieval by an EC2 application has not been tested as part of this lab.
- In a real deployment, an instance profile would associate the role with an EC2 instance, allowing the application to retrieve the secret using temporary IAM credentials.

## Prerequisites

- Terraform CLI
- AWS CLI
- Git
- An AWS account with appropriate IAM permissions
- A configured AWS CLI profile named `terraform-sandbox`
- An existing S3 state bucket configured for remote state and native locking

## Getting Started

Run the following commands from `environments/dev`.

### 1. Prepare the variables file

```powershell
Copy-Item .\dev.tfvars.example .\dev.tfvars
```

Edit `dev.tfvars` and replace the placeholder bucket name with a globally unique S3 bucket name.

The real `dev.tfvars` file is excluded from Git. Do not commit it.

### 2. Initialize Terraform

```powershell
terraform init
```

### 3. Format and validate

```powershell
terraform fmt -recursive
terraform validate
```

### 4. Review the execution plan

```powershell
terraform plan -var-file="dev.tfvars"
```

Review the proposed changes carefully. Confirm that the plan contains only the resources and changes you intend to make.

### 5. Apply only when intended

```powershell
terraform apply -var-file="dev.tfvars"
```

Applying the configuration can create billable AWS resources. Review the plan and expected costs before approval.

**Note:** The existing remote state may already contain deployed resources. Running `terraform apply` is not necessarily a clean first deployment.

## Outputs

The dev environment exposes:

- `bucket_name` — the application S3 bucket name
- `bucket_arn` — the application S3 bucket ARN

## Current Scope and Future Improvements

This is a learning and portfolio project, not a claim of a fully production-certified platform.

Planned improvements include:

- Separate dev, staging, and production environments
- Terraform CI/CD with plan review and controlled apply
- Stronger IAM and multi-account AWS patterns
- Automated security and policy checks
- Documentation and architecture diagrams
- Automated infrastructure testing and validation

## Learning Outcomes

This project demonstrates practical experience with:

- Terraform modules and environment configuration
- Remote state management and native S3 state locking
- Variable validation and resource tagging
- AWS provider configuration and Git workflows
- AWS Secrets Manager and IAM least-privilege permissions
- IAM trust policies versus permissions policies
- Infrastructure security fundamentals
- Safe Terraform planning, application, and resource lifecycle management
