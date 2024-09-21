variable "aws_profile" {
  description = "The AWS profile to use"
  type        = string
}

variable "main_aws_region" {
  description = "The AWS region to use"
  type        = string
  default     = "us-east-1"
}

variable "prefix" {
  description = "The prefix to use for a specific environment (e.g. dev, prod, qa)"
}
