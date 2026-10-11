\# EC2 Secrets Manager Access Lab



\## Overview



This lab demonstrates how an Amazon EC2 instance can retrieve a secret from AWS Secrets Manager using an IAM role, without storing long-lived AWS access keys on the instance.



The lab was implemented using Terraform and AWS Systems Manager Session Manager.



\## Architecture



The lab includes:



\- An Amazon Linux 2023 EC2 instance.

\- An EC2 IAM role and instance profile.

\- AWS Systems Manager permissions for Session Manager access.

\- A least-privilege Secrets Manager reader policy.

\- A security group with no inbound rules and restricted outbound connectivity.

\- An encrypted 8 GiB gp3 root volume.

\- IMDSv2 enforcement.

\- A Secrets Manager secret containing synthetic test data.



The EC2 instance obtained temporary AWS credentials through its IAM role. No long-lived access keys were stored on the instance.



\## Prerequisites



\- An AWS account with permission to create and manage the lab resources.

\- AWS CLI configured locally.

\- Terraform installed.

\- An existing checkout of the `terraform-production` project.

\- The existing Secrets Manager secret resource and `aws\_iam\_policy.secret\_reader` policy defined by that project.

\- A suitable VPC and subnet with connectivity to the AWS Systems Manager and Secrets Manager endpoints, either through appropriate VPC endpoints or internet/NAT connectivity.

\- Permission to use AWS Systems Manager Session Manager.



\## Configuration



The example file is provided as:



`main.tf.example`



It is not automatically loaded by Terraform. To use it, copy it into the project's `environments/dev` directory and rename it to `ec2-lab.tf`.



Supply the following Terraform variables for the lab:



\- `lab\_vpc\_id`: the VPC ID where the instance will run.

\- `lab\_subnet\_id`: the subnet ID where the instance will run.



Use a suitable subnet for your network design. If the subnet needs internet access, configure the necessary routing and security controls. A public IP alone does not guarantee connectivity.



The example also references existing project resources and variables, including `aws\_iam\_policy.secret\_reader`, `environment`, `project\_name`, and `managed\_by`. It is intended to be used with the base project rather than as an independent Terraform configuration.



\## Deployment and validation



1\. Review the example and configure the VPC and subnet IDs.

2\. Copy the example into the Terraform environment only when you intend to deploy the lab.

3\. Initialize Terraform if required.

4\. Run `terraform validate`.

5\. Generate and inspect a Terraform plan.

6\. Apply only after confirming that the proposed changes are expected.

7\. Connect using AWS Systems Manager Session Manager.

8\. Run `aws sts get-caller-identity` to verify the instance's assumed role.

9\. Test access to the secret using AWS CLI commands.

10\. Remove the test resources after validation and verify the final Terraform plan.



Example commands to run from `environments/dev`:



```powershell

terraform init

terraform validate

terraform plan -var-file="dev.tfvars"

```



Supply `lab\_vpc\_id` and `lab\_subnet\_id` through a suitable temporary variable file or explicit `-var` arguments when planning the example. Do not commit real environment-specific values or credentials.



\*\*Important:\*\* Do not apply a plan until you have reviewed the proposed changes. This example can create billable AWS resources.



\## Validation results



During the lab:



\- The EC2 instance successfully obtained temporary credentials through its IAM role.

\- `aws sts get-caller-identity` confirmed the assumed EC2 role.

\- The instance successfully described the Secrets Manager secret.

\- A synthetic, non-sensitive test value was added temporarily and retrieved successfully.

\- The temporary EC2 lab resources were subsequently destroyed.

\- The secret was recreated without a secret value.

\- A final Terraform plan reported no changes.



The validation used synthetic data only. No real application credentials were used.



\## Security considerations



\- Follow least-privilege IAM principles.

\- Scope secret access to the required secret ARN.

\- Do not store AWS access keys in user data, source code, or instance files.

\- Keep the instance's inbound access closed unless a documented requirement exists.

\- Enforce IMDSv2 and encrypt EBS volumes.

\- Avoid printing real secret values in terminal output, logs, screenshots, or CI/CD logs.

\- Review the plan before applying or destroying infrastructure.

\- Review Secrets Manager recovery and deletion settings before deleting production secrets.



\## Cleanup



After testing, remove the temporary lab configuration from the active Terraform environment and review the resulting plan.



Destroy only the resources associated with this lab after verifying the plan carefully. Confirm that unrelated resources, including the application S3 bucket and shared IAM resources, will not be deleted.



The committed example is documentation and source code; it does not mean the lab infrastructure is currently deployed.



\## Skills demonstrated



\- Terraform resource management and reusable configuration.

\- IAM roles, policies, and instance profiles.

\- Secrets Manager access control.

\- EC2 security hardening.

\- Session Manager-based administration.

\- AWS CLI troubleshooting and validation.

\- Infrastructure cleanup and Terraform state verification.



