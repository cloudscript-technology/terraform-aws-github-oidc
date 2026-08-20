variable "organizations" {
  type        = list(string)
  description = "List of GitHub organizations."
}

variable "repo_name" {
  description = "Name of the Github Repository."
  type        = string
  default     = ""
}

variable "additional_policy_documents" {
  description = "List of JSON IAM policy documents"
  type        = list(string)
  default     = []
}

variable "organization_ids" {
  description = <<-EOT
    Numeric GitHub owner (organization) IDs, keyed by organization name — e.g.
    { "my-org" = "186337703" }. Used to build the immutable subject claim
    (`repo:<org>@<owner_id>/...`) that GitHub emits for repositories created
    after the immutable OIDC identifiers rollout. Organizations absent from
    this map fall back to a wildcard in the owner ID position.

    Get the ID with: gh api orgs/<org> --jq .id
  EOT
  type        = map(string)
  default     = {}
}
