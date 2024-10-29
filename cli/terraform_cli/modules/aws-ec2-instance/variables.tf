variable "instance_count" {
  description = "Number of EC2 instances to deploy"
  type        = number
}

variable "instance_name_prefix" {
  description = "Name prefix of the EC2 instance"
  type        = string
}

# variable "subnet_ids" {
#   description = "List of subnet IDs for EC2 instances"
#   type        = list(string)
# }

# variable "security_group_ids" {
#   description = "List of security groupd IDs for EC2 instances"
#   type        = list(string)
# }

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
