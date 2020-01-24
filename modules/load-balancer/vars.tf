# modules/load-balancer/vars.tf


variable region {
  description = "AWS region"
  type        = string
  default     = "eu-west-3"
}

variable env {
  description = "Environment"
  type        = string
}

variable dns_domain_name {
  description = "DNS domain name"
  type        = string
  default     = "codeascode.net"
}

variable tls_certificate_arn {
  description = "TLS certificate ARN for *.codeascode.net domain name"
  type        = string
  default     = "arn:aws:acm:eu-west-3:410131128995:certificate/0f691692-0365-4c72-9dac-117e0181e8f7"
}
