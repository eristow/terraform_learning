output "instance_ids" {
  description = "List of IDs of the EC2 instances"
  value       = aws_instance.app.*.id
}

output "instance_names" {
  description = "List of names of the EC2 instances"
  value       = aws_instance.app.*.tags.Name
}
