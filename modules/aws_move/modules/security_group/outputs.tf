output "security_group_id" {
  description = "The ID of the security group created by this module"
  value       = aws_security_group.sg_8080.id
}
