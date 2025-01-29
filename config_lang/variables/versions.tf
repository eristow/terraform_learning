terraform {
  backend "s3" {
    bucket = "eristow-terraform-state"
    key    = "terraform_config_lang_variables.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.42.0"
    }
  }
  required_version = "~> 1.2"
}
