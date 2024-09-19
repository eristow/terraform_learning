variable "instance_name" {
  description = "Values of the Name tag for the EC2 instance"
  type        = string
  default     = "ExampleAppServerInstance"
}

variable "aws_profile" {
  description = "The AWS profile to use"
  type        = string
}

variable "main_aws_region" {
  description = "The AWS region to use"
  type        = string
}
