# AWS Compute Platform with Terraform and GitHub Actions

This repo deploys an end-to-end AWS compute platform using Terraform modules and GitHub Actions.

## What it builds

- VPC with public and private app subnets
- Internet Gateway and NAT Gateway
- Application Load Balancer
- EC2 Launch Template
- Auto Scaling Group across two Availability Zones
- Root EBS volume and additional data EBS volume
- Security Groups and private subnet Network ACL
- EC2 IAM role with SSM and CloudWatch permissions
- IAM groups for app admins and read-only users
- CloudWatch alarms and SNS topic
- AWS Backup vault, plan, and tag-based backup selection
- GitHub Actions deploy and destroy pipelines
- GitHub OIDC IAM roles for dev and prod

## Important first step

GitHub Actions cannot assume AWS roles until the GitHub OIDC provider and IAM roles exist in AWS.

Bootstrap this once from your local terminal, AWS CloudShell, or another trusted CI runner that already has AWS permissions.

```bash
cd envs/bootstrap-oidc
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars and set github_repo correctly.
terraform init
terraform plan
terraform apply
terraform output
```

Copy the outputs:

```text
DEV_AWS_ROLE_ARN
PROD_AWS_ROLE_ARN
```

Then add them to GitHub Environments.

## GitHub environment setup

Create these GitHub environments:

```text
dev
prod
```

In `dev`, add this environment secret:

```text
DEV_AWS_ROLE_ARN
```

In `prod`, add this environment secret:

```text
PROD_AWS_ROLE_ARN
```

For `prod`, enable required reviewer approval. This makes production deploy and destroy wait for approval.

## Dev deployment

Dev deploy runs automatically on push to main when files under `envs/dev`, `modules`, `scripts`, or the workflow change.

Workflow:

```text
.github/workflows/dev-deploy.yml
```

## Prod deployment

Prod deploy is manual and waits for GitHub Environment approval.

Workflow:

```text
.github/workflows/prod-deploy.yml
```

## Destroy workflows

Manual destroy workflows are included:

```text
.github/workflows/dev-destroy.yml
.github/workflows/prod-destroy.yml
```

Prod destroy also waits for the `prod` environment approval rule.

## Terraform state backend

The backend is configured to use:

```text
bucket       = jay-terraformstate-bucket
region       = us-east-1
encrypt      = true
use_lockfile = true
```

Update backend keys or bucket if needed.

## Before first GitHub Actions deployment

Review and update these files:

```text
envs/dev/terraform.tfvars.example
envs/prod/terraform.tfvars.example
envs/bootstrap-oidc/terraform.tfvars.example
```

The workflows copy the `.example` file to `terraform.tfvars` on the runner if `terraform.tfvars` does not exist.

For real production, store environment-specific values using a safer pattern such as checked-in non-sensitive tfvars plus GitHub variables, or Terraform Cloud/HCP Terraform variables.

## Validation commands

After deployment:

```bash
terraform output application_url
curl http://ALB_DNS_NAME
```

AWS CLI checks:

```bash
aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names <asg-name>
aws elbv2 describe-target-health --target-group-arn <target-group-arn>
aws ssm describe-instance-information
aws cloudwatch describe-alarms --alarm-name-prefix compute-dev
```

## Screenshot guide for blog

1. GitHub repository folder structure
2. GitHub Actions dev deploy success
3. GitHub Actions prod waiting for approval
4. AWS Auto Scaling Group instances
5. Target group healthy checks
6. ALB application URL in browser
7. CloudWatch alarms
8. SSM managed instances
9. AWS Backup vault and backup plan
10. Destroy workflow completion

## Architecture

Mermaid diagram is available here:

```text
docs/architecture.mmd
```

Use draw.io with AWS icon library for a polished blog diagram.

## Change management practice

Recommended flow:

```text
feature branch
terraform fmt
terraform validate
terraform plan
pull request
merge to main
dev auto deploy
validate ALB and CloudWatch
manual prod deploy
prod approval
```

For risky changes:

- Test in dev first
- Review Terraform plan carefully
- Avoid direct console changes
- Keep prod destroy protected
- Use SSM instead of SSH
- Use least-privilege IAM after the demo is working

## Production hardening backlog

- ACM certificate and HTTPS listener
- AWS WAF
- KMS customer-managed keys
- Secrets Manager or SSM Parameter Store for app secrets
- VPC endpoints for SSM, CloudWatch, ECR, and S3
- Multi-account separation
- Least-privilege deployment policy instead of AdministratorAccess
- AMI baking with Packer
- Blue/green deployment strategy
- AWS Config and GuardDuty
# trigger
trigger dev deploy
