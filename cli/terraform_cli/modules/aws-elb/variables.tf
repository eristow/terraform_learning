variable "public_subnets" {
  description = "List of public subnets for the ELB"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the ELB"
  type        = list(string)
}

variable "instance_ids" {
  description = "List of EC2 instance IDs for the ELB"
  type        = list(string)
}
