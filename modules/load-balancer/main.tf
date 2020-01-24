# modules/load-balancer/main.tf


# CLOUD PROVIDER
# --------------

provider aws {
  region      = var.region
}


# retrieve VPC [dev|tst|acc|prd] info
data aws_vpc "my_vpc" {
  tags = {
    Name = "${var.env}"
  }
}


# retrieve VPC subnets info
data aws_subnet_ids my_subnets {
  vpc_id = data.aws_vpc.my_vpc.id
}


## create a network load-balancer
#resource aws_lb load_balancer {
#  name               = var.env
#  internal           = false
#  ip_address_type    = "ipv4"
#  load_balancer_type = "network"
#  subnets            = data.aws_subnet_ids.my_subnets.ids
#  tags = {
#    Name = "${var.env}-load-balancer"
#    env  = var.env
#  }
#}

# create a network load-balancer
resource aws_lb my_load_balancer {
  name               = var.env
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  subnets            = data.aws_subnet_ids.my_subnets.ids
  
  tags = {
    Name = "${var.env}"
  }
}


# create a load-balancer listener for http/80 input traffic
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


# create a load-balancer listener for https/443 input traffic
resource aws_lb_listener https-443 {
  load_balancer_arn = aws_lb.my_load_balancer.arn
  protocol          = "HTTPS"
  #protocol          = "TLS"
  port              = 443
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.tls_certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http-80.arn
  }
}


# create a load-balancer target group for the webservers
resource aws_lb_target_group webservers {
  name        = "webservers"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.my_vpc.id
  target_type = "instance"

  stickiness {
    type    = "lb_cookie"
    enabled = false
  }
  
  tags = {
    Name = "webservers"
    env  = var.env
  }
}
