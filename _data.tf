locals {
  # GitHub emits the subject claim in two shapes, and both have to be accepted:
  #
  #   legacy     repo:<org>/<repo>:<context>
  #   immutable  repo:<org>@<owner_id>/<repo>@<repo_id>:<context>
  #
  # The immutable shape carries the numeric IDs of the owner and of the
  # repository, and is what repositories created after the immutable OIDC
  # identifiers rollout send. A trust policy that only matches the legacy shape
  # rejects those repositories with:
  #
  #   Not authorized to perform sts:AssumeRoleWithWebIdentity
  #
  # The owner ID comes from var.organization_ids when known; otherwise the
  # position is a wildcard. Note that the "@" is always required, so these
  # patterns cannot be matched by an unrelated organization whose name merely
  # starts with one of ours (which "repo:<org>*" would allow).
  subject_claims = flatten([
    for org in var.organizations : (
      var.repo_name != "" ? [
        "repo:${org}/${var.repo_name}:*",
        "repo:${org}@${lookup(var.organization_ids, org, "*")}/${var.repo_name}@*:*",
        ] : [
        "repo:${org}/*",
        "repo:${org}@${lookup(var.organization_ids, org, "*")}/*",
      ]
    )
  ])
}

data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = local.subject_claims
    }
  }
}

data "aws_iam_policy_document" "github_actions" {
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:ListImages",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "ecr:GetAuthorizationToken",
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "custom_policies" {
  count = length(var.additional_policy_documents) > 0 ? 1 : 0

  override_policy_documents = var.additional_policy_documents
}
