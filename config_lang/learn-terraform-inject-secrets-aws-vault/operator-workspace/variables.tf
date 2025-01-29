variable "project_name" {
  type        = string
  description = "Name of the example project."

  default = "dynamic-aws-creds-operator"
}

variable "region" {
  type        = string
  description = "AWS region for all resources."

  default = "us-east-1"
}

# variable "vault_state_path" {
#   type        = string
#   description = "Path to state file of vault admin workspace."

#   default = "../vault-admin-workspace/terraform.tfstate"
# }
variable "s3_state_bucket" {
  type        = string
  description = "Name of S3 bucket holding state file"

  default = "eristow-terraform-state"
}

variable "s3_state_bucket_key" {
  type        = string
  description = "Name of key in S3 state bucket"

  default = "terraform_config_lang_vault.tfstate"
}

variable "ttl" {
  type        = string
  description = "Value for TTL tag."

  default = "1"
}
