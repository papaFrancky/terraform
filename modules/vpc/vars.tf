# modules/vpc/vars.tf
# -------------------


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

variable cidr {
    description = "VPC cidr block"
    type        = string
    default     = "10.0.0.0/16"
}

