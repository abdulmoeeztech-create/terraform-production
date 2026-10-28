
### 3.3 Create `docs\self-healing-test.md`

```powershell
@'
# Self-Healing Test: EC2 Auto Scaling

## Objective

Verify that the EC2 Auto Scaling Group replaces a terminated instance when desired capacity is maintained, and confirm that the application remains reachable through the Application Load Balancer.

## Environment

| Setting | Value |
|---|---|
| AWS Region | `ap-south-1` |
| Auto Scaling Group | `terraform-production-dev-app-asg` |
| Desired capacity | 1 |
| Minimum capacity | 1 |
| Maximum capacity | 1 |
| Load balancer | `terraform-production-dev-alb` |
| Target group | `terraform-production-dev-tg` |
| Application protocol | HTTP |
| Health check path | `/` |

## Test Procedure

1. Confirm that the application responds through the ALB.
2. Confirm that the original EC2 instance is registered as a healthy target.
3. Terminate the original instance using the Auto Scaling API without decrementing desired capacity.
4. Observe the ASG launch a replacement instance.
5. Verify that the replacement reaches `InService` and reports healthy status.
6. Verify that the old instance is removed from the ASG.
7. Request the application through the ALB again.

## Observed Results

| Check | Result |
|---|---|
| ASG desired capacity | 1 |
| Replacement instance ID | `i-088c9f2dcfd31ade4` |
| Replacement lifecycle | `InService` |
| Replacement health status | `Healthy` |
| ALB response | HTTP 200 |
| Application response body | `Infra2Agent application is healthy` |
| Original instance removed from ASG | Confirmed |

## Outcome

**Passed:** The ASG restored its desired capacity after the original instance was terminated. The replacement instance became healthy, and the application continued responding through the ALB.

This validates the tested instance-replacement scenario. It does not prove zero downtime, multi-instance high availability, or recovery from every possible failure.

## Evidence to Capture

Save genuine screenshots from the AWS console or terminal in the repository's `screenshots/` folder:

- `asg-healthy.png` — ASG showing the replacement in `InService`.
- `target-group-healthy.png` — target group showing the replacement as healthy.
- `alb-http-200.png` — PowerShell showing HTTP 200 and the application response.

Redact account identifiers and any information you do not want publicly visible. Do not include credentials, private keys, Terraform state, or secret values.

## Reproduction Commands

Inspect ASG capacity and instance lifecycle:

```powershell
aws autoscaling describe-auto-scaling-groups `
  --auto-scaling-group-names terraform-production-dev-app-asg `
  --query "AutoScalingGroups[0].{Desired:DesiredCapacity,Instances:Instances[*].{Id:InstanceId,Health:HealthStatus,Lifecycle:LifecycleState}}" `
  --profile terraform-sandbox `
  --region ap-south-1