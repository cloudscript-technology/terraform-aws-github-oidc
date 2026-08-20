## terraform-aws-github-oidc

This Terraform module creates a trust relationship via OpenID Connect (OIDC) between multiple GitHub organizations and Amazon Web Services (AWS). Allowing services like GitHub 
Actions to send images to the ECR without the need to use Accesskeys and Secretkeys, using Role.


## Usage

Allowing all repositories for multiple organizations
```
module "github-oidc" {
    source = "git@github.com:cloudscript-technology/terraform-aws-github-oidc?ref=v1.0"
    
    organizations = ["ORG-1", "ORG-2"]
}
```
Allowing single repository from multiple organizations
```
module "github-oidc" {
    source = "git@github.com:cloudscript-technology/terraform-aws-github-oidc?ref=v1.0"
    
    organizations = ["ORG-1", "ORG-2"]
    repo_name     = "REPO-NAME"
}
```

If `repo_name` is not set, the module allows all repositories for the organizations listed in `organizations`.

### Immutable subject claims

GitHub emits the OIDC subject claim in two shapes:

```
legacy      repo:<org>/<repo>:<context>
immutable   repo:<org>@<owner_id>/<repo>@<repo_id>:<context>
```

Repositories created after the immutable OIDC identifiers rollout send the
second shape. A trust policy that only matches the legacy shape rejects them
with `Not authorized to perform sts:AssumeRoleWithWebIdentity`, even though the
role, the provider and the policies are all correct. This module always allows
both shapes.

Pass the numeric owner ID of each organization so that the immutable pattern is
pinned instead of wildcarded:

```
module "github-oidc" {
    source = "git@github.com:cloudscript-technology/terraform-aws-github-oidc?ref=v2.1.0"

    organizations    = ["ORG-1", "ORG-2"]
    organization_ids = { "ORG-1" = "186337703" }
}
```

Get the ID with `gh api orgs/<org> --jq .id`. Organizations left out of the map
get a wildcard in the owner ID position, which still works — it just trusts any
owner ID behind the organization name.

Note that the `@` separator is always required in the immutable pattern. Writing
the condition as `repo:<org>*` would also match an unrelated organization whose
name merely starts with yours, which anyone can create.

___

**__data.tf_**
```
data "aws_iam_policy_document" "github_actions_assume_role" {
    ...
    values   = local.subject_claims   # legacy + immutable shapes, per organization
    ...
```


___
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_policy.custom_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.github_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.github_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.custom_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.github_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.custom_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.github_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.github_actions_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_policy_documents"></a> [additional\_policy\_documents](#input\_additional\_policy\_documents) | List of JSON IAM policy documents | `list(string)` | `[]` | no |
| <a name="input_organization_ids"></a> [organization\_ids](#input\_organization\_ids) | Numeric GitHub owner (organization) IDs, keyed by organization name, used to build the immutable subject claim. | `map(string)` | `{}` | no |
| <a name="input_organizations"></a> [organizations](#input_organizations) | List of GitHub Organizations. | `list(string)` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | Name of the Github Repository. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_oidc_arn"></a> [oidc\_arn](#output\_oidc\_arn) | n/a |
| <a name="output_role_github_arn"></a> [role\_github\_arn](#output\_role\_github\_arn) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->