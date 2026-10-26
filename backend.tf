terraform {
  backend "s3" {
    bucket = "gitops-terraform-state91"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}
