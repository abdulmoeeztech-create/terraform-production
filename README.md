# Production-Style AWS Terraform Infrastructure



A hands-on Infrastructure as Code (IaC) project demonstrating reusable Terraform modules, remote state management, input validation, and secure configuration practices on AWS.



## Project Objectives



- Build reusable Terraform modules for AWS resources.

- Separate environment configuration from reusable infrastructure code.

- Store Terraform state remotely in Amazon S3.

- Use native S3 state locking with Terraform.

- Validate inputs and maintain consistent resource tags.

- Protect state files and environment-specific configuration from accidental Git commits.



## Architecture



```text

terraform-production/

â”œâ”€â”€ .gitignore

â”œâ”€â”€ README.md

â”œâ”€â”€ environments/

â”‚   â””â”€â”€ dev/

â”‚       â”œâ”€â”€ main.tf

â”‚       â”œâ”€â”€ variables.tf

â”‚       â”œâ”€â”€ outputs.tf

â”‚       â”œâ”€â”€ dev.tfvars.example

â”‚       â””â”€â”€ .terraform.lock.hcl

â””â”€â”€ modules/

&#x20;   â””â”€â”€ s3/

&#x20;       â”œâ”€â”€ main.tf

&#x20;       â”œâ”€â”€ variables.tf

&#x20;       â””â”€â”€ outputs.tf

```



### Infrastructure flow



- Terraform uses the AWS provider in `ap-south-1`.

- The dev environment calls a reusable S3 module.

- The application bucket name, environment, project, and management tags are configurable.

- Terraform state is stored in an S3 backend, with native S3 state locking enabled.



## AWS and Terraform Features



- Amazon S3

- Terraform S3 backend

- Native S3 state locking (`use\_lockfile = true`)

- Reusable Terraform modules

- Input variables and validation rules

- Resource tags

- Terraform provider version constraints

- Git version control and `.gitignore`



The state backend is managed separately from this application infrastructure repository.



## Security Practices



- Exclude Terraform state files and backups from Git.

- Exclude `.tfvars` files and environment-specific values.

- Commit an example variable template instead of the real dev variables file.

- Use a local AWS CLI profile rather than storing AWS credentials in Terraform code.

- Keep the Terraform state bucket private and protected by appropriate AWS access controls.



\*\*Important:\*\* `.gitignore` helps prevent accidental commits but does not replace IAM permissions, secret management, or state-backend security controls.



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

Copy-Item .\\dev.tfvars.example .\\dev.tfvars

```



Edit `dev.tfvars` and replace the placeholder bucket name with a globally unique S3 bucket name.



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



Review the plan carefully before applying any changes.



### 5. Apply only when intended



```powershell

terraform apply -var-file="dev.tfvars"

```



Applying the configuration can create billable AWS resources. Review the plan and expected costs before approval.



## Outputs



The dev environment exposes:



- `bucket\_name` â€” the application S3 bucket name

- `bucket\_arn` â€” the application S3 bucket ARN



## Current Scope and Future Improvements



This is a learning and portfolio project, not a claim of a fully production-certified platform.



Planned improvements include:



- Separate dev, staging, and production environments

- Terraform CI/CD with plan review and controlled apply

- Stronger IAM and multi-account AWS patterns

- Automated security and policy checks

- Documentation and architecture diagrams



## Learning Outcomes



This project demonstrates practical experience with Terraform modules, remote state, state locking, variable validation, AWS provider configuration, Git workflows, and infrastructure security fundamentals.
