
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "app" {
  count = var.instance_count

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  # subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  # vpc_security_group_ids = var.security_group_ids

  tags = {
    Name  = "${var.instance_name_prefix}-${count.index}"
    Owner = "${var.project_name}-tutorial"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y apache2
    sed -i -e 's/80/8080/' /etc/apache2/ports.conf
    echo "Hello World" > /var/www/html/index.html
    systemctl restart apache2
  EOF
}
