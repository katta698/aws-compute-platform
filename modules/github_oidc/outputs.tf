output "dev_role_arn" {
  value = aws_iam_role.github_dev_role.arn
}

output "prod_role_arn" {
  value = aws_iam_role.github_prod_role.arn
}

output "oidc_provider_arn" {
  value = local.oidc_provider_arn
}
