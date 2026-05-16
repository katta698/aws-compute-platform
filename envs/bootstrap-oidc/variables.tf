variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "name_prefix" {
  type    = string
  default = "compute-platform"
}

variable "github_repo" {
  type    = string
  default = "katta698/aws-compute-platform"
}

variable "owner" {
  type    = string
  default = "jay"
}

variable "create_oidc_provider" {
  type    = bool
  default = false
}

variable "existing_oidc_provider_arn" {
  type    = string
  default = "arn:aws:iam::684346483786:oidc-provider/token.actions.githubusercontent.com"
}