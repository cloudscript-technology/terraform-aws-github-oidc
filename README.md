## terraform-aws-github-oidc

This Terraform module creates a trust relationship via OpenID Connect (OIDC) between GitHub and Amazon Web Services (AWS). Allowing services like GitHub 
Actions to send images to the ECR without the need to use Accesskeys and Secretkeys, using Role.


## Usage

Allowing all repository for an organization
```
module "github-oidc" {
    source = "git@github.com:cloudscript-technology/terraform-aws-github-oidc?ref=v1.0"
    
    organization = "ORGANIZATIONNAME"    
}
```
Allowing single repository from an organization
```
module "github-oidc" {
    source = "git@github.com:cloudscript-technology/terraform-aws-github-oidc?ref=v1.0"
    
    organization = "ORGANIZATION-NAME"
    repo_name    = "REPO-NAME"
}
```

We have a condition in the code where if the value of repo_name is 
null the logic allows all repositories in the organization.

___

**__data.tf_**
```
data "aws_iam_policy_document" "github_actions_assume_role" {
    ...
    values   = var.repo_name != ""  ? ["repo:${var.organization}/${var.repo_name}:*"] : ["repo:${var.organization}/*"]
    ...
```


___
**In the near future we can create logic to interpret a list of repositories.**
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
| <a name="input_organization"></a> [organization](#input\_organization) | Name of the Github Organization. | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | Name of the Github Repository. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_oidc_arn"></a> [oidc\_arn](#output\_oidc\_arn) | n/a |
| <a name="output_role_github_arn"></a> [role\_github\_arn](#output\_role\_github\_arn) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->