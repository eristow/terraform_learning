variable "region" {
  description = "AWS region for all resources"
  type        = string

  default = "us-east-1"
}

variable "project_name" {
  description = "Name of the example project"
  type        = string

  default = "terraform-init"
}

variable "secret_key" {
  description = "Secret key for the hello module"
  type        = string
  sensitive   = true
}
