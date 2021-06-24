variable "aws_region" {
  default = "us-east-1"
  description = "AWS region"
}

locals {
  availability_zone1 = format("%s%s", var.aws_region, "a")
  availability_zone2 = format("%s%s", var.aws_region, "b")

  availability_zones = [ local.availability_zone1, local.availability_zone2 ]
}

# --------- EC2 parameters -----------

variable "ssh_key_name" {
  default     = "demo_gl_basecamp"
  description = "Name of the SSH keypair to use in AWS."
}

variable "ec2_instance_type" {
  description = "AWS EC2 instance type"
  default   = "t2.micro"
}

variable "webapp_port" {
  default = 80
}