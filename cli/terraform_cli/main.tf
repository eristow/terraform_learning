provider "aws" {
  region = var.region
}

provider "random" {}

provider "time" {}

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

resource "random_pet" "instance" {
  length = 2
}

module "ec2-instance" {
  source = "./modules/aws-ec2-instance"
  count  = 3

  ami_id        = data.aws_ami.ubuntu.id
  instance_name = "${random_pet.instance.id}-${count.index}"
}

module "s3_bucket" {
  source = "./modules/aws-s3-bucket"

  bucket_name = "eristow-terraform-s3-bucket"
}

resource "aws_s3_object" "example" {
  bucket = module.s3_bucket.bucket_name

  key    = "README.md"
  source = "./README.md"

  etag = filemd5("./README.md")
}

module "hello" {
  source  = "joatmon08/hello/random"
  version = "6.0.0"

  hellos = {
    hello        = random_pet.instance.id
    second_hello = "World"
  }

  some_key = var.secret_key
}
