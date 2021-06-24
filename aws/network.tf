resource "aws_vpc" "demo_vpc" {
  cidr_block           = "10.0.0.0/16"
}

resource "aws_subnet" "demo_subnet" {
  for_each = toset(local.availability_zones)
  vpc_id                  = aws_vpc.demo_vpc.id
  availability_zone       = each.key
  cidr_block              = format("%s%s%s", "10.0.", index(local.availability_zones, each.key), ".0/24")
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "demo_gateway" {
  vpc_id      = aws_vpc.demo_vpc.id
}

resource "aws_route_table" "demo_route_table" {
  vpc_id = aws_vpc.demo_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_gateway.id
  }
}

resource "aws_main_route_table_association" "demo_main_route_table_association" {
  vpc_id          = aws_vpc.demo_vpc.id
  route_table_id  = aws_route_table.demo_route_table.id
}

resource "aws_security_group" "demo_secgroup" {
  name        = "demo_security_group"
  description = "demo_security_group"
  vpc_id      = aws_vpc.demo_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port   = var.webapp_port
    to_port     = var.webapp_port
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  # Dependency is used to ensure that VPC has an Internet gateway or this step will fail
  depends_on = [ aws_internet_gateway.demo_gateway ]
}
