# modules/load-balancer/outputs.tf

output alb_dns_native_name {
  value = aws_lb.my_load_balancer.dns_name
}

output tls_certificate_arn {
  value = var.tls_certificate_arn
}
