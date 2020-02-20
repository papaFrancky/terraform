# dev/load-balancer/outputs.tf


output alb_dns_native_name {
  value = module.load-balancer.alb_dns_native_name
}

output tls_certificate_arn {
  value = module.load-balancer.tls_certificate_arn
}
