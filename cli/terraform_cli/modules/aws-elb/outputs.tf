output "elb_url" {
  description = "URL of the ELB"
  value       = "http://${module.elb_http.elb_dns_name}/"
}
