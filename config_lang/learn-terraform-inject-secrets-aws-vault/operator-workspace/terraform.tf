terraform {
  backend "s3" {
    bucket = "eristow-terraform-state"
    key    = "terraform_config_lang_vault_operator.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.84.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.6.0"
    }
  }
}
