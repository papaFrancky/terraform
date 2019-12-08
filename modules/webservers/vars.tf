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
  default     = "t2.micro"
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