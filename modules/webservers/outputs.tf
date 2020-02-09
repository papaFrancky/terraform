# modules/webservers/outputs.tf
# -----------------------------


output elb_dns_native_name {
  value = data.aws_lb.my_load_balancer.dns_name

  depends_on = [
    aws_lb.my_load_balancer
  ]
}


output elb_dns_alias {
  value = "www-${var.env}.${var.dns_domain_name}"
}


output elb_instances {
  value = data.aws_lb.my_load_balancer.name

  depends_on = [
    aws_lb.my_load_balancer
  ]
}


output sns_topic_name {
  value = data.aws_sns_topic.my_topic.name
}


output sns_topic_arn {
  value = data.aws_sns_topic.my_topic.arn
}
