resource "aws_iam_role" "github_actions" {
  name               = "github-actions-org-${var.organizations[0]}"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json
}

resource "aws_iam_policy" "github_actions" {
  name        = "github-actions-${var.organizations[0]}"
  description = "Grant Github Actions the ability to push to ${var.organizations[0]}"
  policy      = data.aws_iam_policy_document.github_actions.json
}

resource "aws_iam_policy" "custom_policies" {
  count       = length(var.additional_policy_documents) > 0 ? 1 : 0
  name        = "github-actions-${var.organizations[0]}-custom-policies"
  description = "Grant Github Actions the ability to push to ${var.organizations[0]}"
  policy      = data.aws_iam_policy_document.custom_policies[0].json
}

resource "aws_iam_role_policy_attachment" "github_actions" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions.arn
}

resource "aws_iam_role_policy_attachment" "custom_policies" {
  count      = length(var.additional_policy_documents) > 0 ? 1 : 0
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.custom_policies[0].arn
}
