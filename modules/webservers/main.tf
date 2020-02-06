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
  name_prefix                 = "${var.env}-webservers-"
  image_id                    = data.aws_ami.amazon_latest.id
  associate_public_ip_address = false
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

data aws_vpc my_vpc {
  tags = {
    Name = var.env
  }
}

data aws_subnet_ids my_subnets {
  vpc_id = data.aws_vpc.my_vpc.id

  tags = {
    subnet = "public"
  }
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
  desired_capacity      = var.nb_servers_min

  tags = [
    {
      key                 = "Name"
      value               = "${var.env}-webservers"
      propagate_at_launch = true
    },
    {
      key                 = "env"
      value               = var.env
      propagate_at_launch = true
    }
  ] 
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

data aws_security_group admin_instance {
  name          = "admin"
}

resource aws_security_group webservers {
  name          = "webservers"
  description   = "Web servers security group"
  vpc_id        = data.aws_vpc.my_vpc.id
  
  ingress {
    description = "Full access from the admin instance"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    security_groups = [ data.aws_security_group.admin_instance.id ]
  }

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



# INSTANCE PROFILE
# ----------------

resource aws_iam_role webservers {
  name                  = "webservers"
  description           = "IAM role for web servers"
  assume_role_policy    = file("${path.module}/files/ec2-trust.json")

  tags = {
      Name = "webservers"
  }
}

resource aws_iam_instance_profile webservers {
  name      = "webservers"
  role      = aws_iam_role.webservers.name
}

resource aws_iam_role_policy ec2-access {
  name      = "ec2-access"
  role      = aws_iam_role.webservers.id
  policy    = file("${path.module}/files/ec2-access.json")
}

resource aws_iam_role_policy s3-access {
  name      = "s3-access"
  role      = aws_iam_role.webservers.id
  policy    = file("${path.module}/files/s3-access.json")
}



# DNS ALIAS
# ---------

resource aws_route53_record webservers_prod {
  count = var.use_prod_cname == true ? 1 : 0

  allow_overwrite = true
  zone_id         = var.dns_zone_id
  name            = "www.${var.dns_domain_name}"
  type            = "CNAME"
  ttl             = "60"
  records         = [ data.aws_lb.my_load_balancer.dns_name ]
}

resource aws_route53_record webservers_noprod {
  count = var.use_prod_cname == false ? 1 : 0

  allow_overwrite = true
  zone_id         = var.dns_zone_id
  name            = "${var.env}.${var.dns_domain_name}"
  type            = "CNAME"
  ttl             = "60"
  records         = [ data.aws_lb.my_load_balancer.dns_name ]
}