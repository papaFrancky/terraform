# modules/webservers/main.tf
# --------------------------



# CLOUD PROVIDER
# --------------

provider aws {
  region      = var.region
}



# LAUNCH CONFIGURATION
# --------------------

resource aws_launch_configuration webservers {
  name                        = "${var.env}-webservers"
  image_id                    = data.aws_ami.amazon_latest.id
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.webservers.id
  instance_type               = var.instance_type
  key_name                    = var.ssh_key
  security_groups             = [ aws_security_group.webservers.id ]
  user_data                   = file("${path.module}/files/user-data.bash")
  lifecycle {
    create_before_destroy = true
  }
}



# AUTO SCALING GROUP
# ------------------

data aws_vpc "my_vpc" {
  tags = {
    Name = "${var.env}"
  }
}

data aws_subnet_ids my_subnets {
  vpc_id = data.aws_vpc.my_vpc.id
}

data aws_lb_target_group webservers {
  name = "webservers"
}

data aws_lb my_load_balancer {
  name = var.env
}

resource aws_autoscaling_group webservers {
  name                  = "${var.env}-webservers"
  launch_configuration  = aws_launch_configuration.webservers.id
  vpc_zone_identifier   = data.aws_subnet_ids.my_subnets.ids
  target_group_arns     = [ data.aws_lb_target_group.webservers.arn ]
  health_check_type     = "ELB"

  min_size              = var.nb_servers_min
  max_size              = var.nb_servers_max

  tag {
    key                 = "Name"
    value               = "${var.env}-webservers"
    propagate_at_launch = true
  }
}



# LATEST AMAZON LINUX AMI
# -----------------------

data aws_ami amazon_latest {
    most_recent = true
    owners      = [ "amazon" ]

    filter {
        name    = "name"
        values  = [ "amzn2-ami-*" ]
    }

    filter {
        name    = "virtualization-type"
        values  = [ "hvm" ]
    }
}



# SECURITY GROUPS
# ---------------

data aws_security_group load-balancer {
  name = "load-balancer"
}

resource aws_security_group webservers {
  name          = "webservers"
  description   = "Web servers security group"
  vpc_id        = data.aws_vpc.my_vpc.id
  
  ingress {
    description = "HTTP from load-balancer"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    security_groups = [ data.aws_security_group.load-balancer.id ]
  }

  ingress {
    description = "HTTPs from load-balancer"
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    security_groups = [ data.aws_security_group.load-balancer.id ]
  }


  ingress {
    description = "HTTP from anywhere"
    protocol    = "tcp"
    from_port   = var.http_port
    to_port     = var.http_port
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "SSH from anywhere"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "ICMP from anywhere"
    protocol    = "icmp"
    from_port   = -1
    to_port     = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

   tags = {
      Name = "webservers"
  }
}



# DNS ALIAS
# ---------

resource aws_route53_record webservers {
  allow_overwrite = true
  zone_id         = var.dns_zone_id
  name            = "www-${var.env}.${var.dns_domain_name}"
  type            = "CNAME"
  ttl             = "60"
  records         = [ data.aws_lb.my_load_balancer.dns_name ]
}
