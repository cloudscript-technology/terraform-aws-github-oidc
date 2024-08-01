output "oidc_arn" {
  value = aws_iam_openid_connect_provider.github.arn
}

output "role_github_arn" {
  value = aws_iam_role.github_actions.arn
}