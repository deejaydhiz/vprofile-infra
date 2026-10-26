# vprofile EKS infrastructure

Terraform configuration for a minimal Amazon EKS cluster in `us-east-1`.

## Architecture

- VPC using `10.0.0.0/16`
- Two public subnets across `us-east-1a` and `us-east-1b`, with direct internet access
- EKS cluster with a public API endpoint
- Managed node group using one `t3.large` instance by default (autoscaling range: 1–2)
- EBS CSI driver EKS add-on using IAM Roles for Service Accounts (IRSA)
- S3 remote state backend; DynamoDB locking is not configured

There are no private subnets or NAT gateways. Worker nodes are in public subnets. Review your network and cluster endpoint access requirements before applying this configuration in production.

## Prerequisites

- Terraform `>= 1.5.0`
- AWS credentials configured for an account with permissions to manage the required VPC, IAM, and EKS resources
- An existing S3 bucket for Terraform state

## Initialize and deploy

Initialize the S3 backend, replacing the placeholder with your existing bucket name:

```sh
terraform init -backend-config="bucket=YOUR_TERRAFORM_STATE_BUCKET"
```

Review and apply the infrastructure:

```sh
terraform validate
terraform plan
terraform apply
```

The backend uses the state key `vprofile/eks/terraform.tfstate` in `us-east-1`. The bucket must exist before initialization. No DynamoDB table or state locking is configured.

## Outputs

- `cluster_endpoint` — Kubernetes API endpoint
- `cluster_name` — EKS cluster name
- `cluster_arn` — EKS cluster ARN

To remove the resources managed by this configuration, run `terraform destroy`.
