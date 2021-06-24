output "demo_elb_public_dns" {
  value = aws_lb.demo_lb.dns_name
}