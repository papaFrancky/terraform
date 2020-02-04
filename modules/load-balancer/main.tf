# modules/load-balancer/main.tf


# cloud provider
provider aws {
  region      = var.region
}


# vpc [dev|tst|acc|prd] info
data aws_vpc "my_vpc" {
  tags = {
    Name = var.env
  }
}


# vpc subnets info
data aws_subnet_ids my_public_subnets {
  vpc_id = data.aws_vpc.my_vpc.id

  tags = {
    subnet = "public"
  }
}


# application load-balancer
resource aws_lb my_load_balancer {
  name               = var.env
  internal           = false
  load_balancer_type = "application"
  security_groups    = [ aws_security_group.load-balancer.id ]
  ip_address_type    = "ipv4"
  subnets            = data.aws_subnet_ids.my_public_subnets.ids
  
  tags = {
    Name = var.env
    env  = var.env
  }
}


# application load-balancer security group
 resource aws_security_group load-balancer {
  name          = "load-balancer"
  description   = "Load-balancer security group"
  vpc_id        = data.aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "load-balancer"
  }
}


# load-balancer listener for http/80 input traffic
resource aws_lb_listener http-80 {
  load_balancer_arn = aws_lb.my_load_balancer.arn
  protocol          = "HTTP"
  port              = 80
  default_action {
    type = "redirect"

    redirect {
      protocol    = "HTTPS"
      port        = 443
      status_code = "HTTP_301"
    }
  }
}


# load-balancer listener for https/443 input traffic
resource aws_lb_listener https-443 {
  load_balancer_arn = aws_lb.my_load_balancer.arn
  protocol          = "HTTPS"
  port              = 443
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.tls_certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webservers.arn
  }
}


# load-balancer target group corresponding to the webservers
resource aws_lb_target_group webservers {
  name                 = "webservers"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = data.aws_vpc.my_vpc.id
  target_type          = "instance"
  deregistration_delay = 0

  stickiness {
    type    = "lb_cookie"
    enabled = false
  }
  
  tags = {
    Name = "webservers"
    env  = var.env
  }
}
