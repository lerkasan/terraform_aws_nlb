terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=3.46.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "demo_vm" {
  for_each = toset(local.availability_zones)
  availability_zone = each.key
  subnet_id = aws_subnet.demo_subnet[each.key].id
  ami = data.aws_ami.ubuntu.id
  instance_type = var.ec2_instance_type
  user_data = file("./userdata.sh")
  key_name = var.ssh_key_name
  vpc_security_group_ids = [ aws_security_group.demo_secgroup.id ]
  tags = {
    name = "demo"
  }
}

resource "aws_lb" "demo_lb" {
  name               = "demo-lb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.demo_subnet["${local.availability_zone1}"].id, aws_subnet.demo_subnet["${local.availability_zone2}"].id]
  tags = {
    name = "demo"
  }
}

resource "aws_lb_target_group" "demo_target_group" {
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.demo_vpc.id
}

resource "aws_lb_target_group_attachment" "demo_target_group_attach" {
  for_each = toset(local.availability_zones)
  target_group_arn = aws_lb_target_group.demo_target_group.arn
  target_id        = aws_instance.demo_vm[each.key].id
  port             = 80
}

resource "aws_lb_listener" "demo_lb_listener" {
  load_balancer_arn = aws_lb.demo_lb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.demo_target_group.arn
  }
}