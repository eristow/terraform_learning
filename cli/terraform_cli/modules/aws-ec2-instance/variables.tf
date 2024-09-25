variable "ami_id" {
  description = "AMI id for instance"
  type        = string
}

variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "project_name" {
  description = "Name of the example project"
  type        = string

  default = "terraform-init"
}

variable "instance_type" {
  description = "Instance type for the  EC2 instance"
  type        = string

  default = "t2.micro"
}
