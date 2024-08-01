variable "organization" {
  description = "Name of the Github Organization."
  type        = string
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
