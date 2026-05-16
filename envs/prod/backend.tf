terraform {
  backend "s3" {
    bucket       = "jay-terraformstate-bucket"
    key          = "aws-compute-platform/prod/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
