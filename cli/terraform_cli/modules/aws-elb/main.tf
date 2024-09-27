resource "random_string" "lb_id" {
  length  = 3
  special = false
}

module "elb_http" {
  source  = "terraform-aws-modules/elb/aws"
  version = "4.0.2"

  # Ensure load balancer name is unique
  name = "lb-${random_string.lb_id.result}-project-alpha-dev"

  internal = false

  security_groups = var.security_group_ids
  subnets         = var.public_subnets

  number_of_instances = length(var.instance_ids)
  instances           = var.instance_ids

  listener = [{
    instance_port     = "80"
    instance_protocol = "HTTP"
    lb_port           = "80"
    lb_protocol       = "HTTP"
  }]

  health_check = {
    target              = "HTTP:80/index.html"
    interval            = 10
    timeout             = 3
    healthy_threshold   = 10
    unhealthy_threshold = 5
  }
}
