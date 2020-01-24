# modules/webservers/outputs.tf
# -----------------------------


output elb_dns_native_name {
  value = aws_elb.webservers.dns_name

  depends_on = [
    aws_elb.webservers
  ]
}


output elb_dns_alias {
  value = "www-${var.env}.${var.dns_domain_name}"
}


output elb_instances {
  value = aws_elb.webservers.instances

  depends_on = [
    aws_elb.webservers
  ]
}
