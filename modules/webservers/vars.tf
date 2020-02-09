# modules/webservers/vars.tf
# --------------------------


# INPUT VARIABLES
# ---------------

variable region {
  description = "AWS region"
  type        = string
  default     = "eu-west-3"
}

variable env {
  description = "Environment"
  type        = string
}

variable instance_type {
  description = "EC2 instance type"
  type        = string
}


variable ssh_key {
  description = "SSH key"
  type        = string
  default     = "webservers"
}


variable http_port {
  description = "HTTP port"
  type        = string
  default     = 80
}

variable nb_servers_min {
  description = "Minimum number of servers managed by the auto-scaling group"
  type        = string
}

variable nb_servers_max {
  description = "Maximum number of servers managed by the auto-scaling group"
  type        = string
}

variable dns_zone_id {
  description = "DNS hosted zone ID"
  type        = string
  default     = "Z12Y4ZPECZULO5"
}

variable dns_domain_name {
  description = "DNS domain name"
  type        = string
  default     = "codeascode.net"
}

variable use_prod_cname {
  description = "If set to true, FQDN suffix will be 'www'. IF not, the env (dev|tst|acc) will be used."
  type        = bool
  default     = false
}

variable sns_topic {
  description = "SNS topic name" 
  type        = string
}