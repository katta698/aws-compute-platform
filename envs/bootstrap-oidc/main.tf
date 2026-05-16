terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket       = "jay-terraformstate-bucket"
    key          = "aws-compute-platform/bootstrap-oidc/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region
}

module "github_oidc" {
  source                     = "../../modules/github_oidc"
  name_prefix                = var.name_prefix
  github_repo                = var.github_repo
  create_oidc_provider       = var.create_oidc_provider
  existing_oidc_provider_arn = var.existing_oidc_provider_arn

  tags = {
    Project   = "aws-compute-platform"
    ManagedBy = "Terraform"
    Owner     = var.owner
  }
}
