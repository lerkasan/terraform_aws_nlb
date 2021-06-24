data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [ "bitnami-nginx-1.21.0-0-linux-debian-10-x86_64-hvm*" ]
//    values = [ "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*" ]
  }

  filter {
    name   = "virtualization-type"
    values = [ "hvm" ]
  }

  owners = [ "679593333241" ] # Bitnami
//  owners = [ "099720109477" ] # Canonical
}
