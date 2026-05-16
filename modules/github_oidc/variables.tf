variable "name_prefix" {
  description = "Prefix for IAM role names."
  type        = string
}

variable "github_repo" {
  description = "GitHub repo in owner/repo format, for example katta698/30-days-aws-terraform."
  type        = string
}

variable "create_oidc_provider" {
  description = "Set false if the GitHub OIDC provider already exists in this AWS account."
  type        = bool
  default     = true
}

variable "existing_oidc_provider_arn" {
  description = "Existing GitHub OIDC provider ARN if create_oidc_provider is false."
  type        = string
  default     = ""
}

variable "github_oidc_thumbprint" {
  description = "Thumbprint for token.actions.githubusercontent.com. Validate in production before use."
  type        = string
  default     = "6938fd4d98bab03faadb97b34396831e3780aea1"
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
