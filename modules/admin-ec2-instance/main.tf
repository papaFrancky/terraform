# modules/admin-ec2-instance/main.tf


# CLOUD PROVIDER
# --------------

provider aws {
  region      = var.region
}


# EC2 INSTANCE
# ------------

# admin ec2 instance
resource aws_instance admin {
    ami                         = data.aws_ami.amazon-latest.id
    associate_public_ip_address = true
    iam_instance_profile        = aws_iam_instance_profile.admin.id
    instance_type               = var.instance_type
    key_name                    = var.ssh_key
    vpc_security_group_ids      = [ aws_security_group.admin.id ]
    subnet_id                   = data.aws_subnet.public_subnet.id
    user_data                   = file("${path.module}/files/user-data.bash")

    tags = {
        "Name" = "${var.env}-admin"
    }
}

# latest amazon linux ami
data "aws_ami" "amazon-latest" {
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

# az1 public subnet
data aws_subnet public_subnet {
    tags = {
        Name = "${var.env}-public-${var.region}a"
    }
    #filter {
    #    name    = "tag:Name"
    #    values  = [ "${var.env}-public-${var.region}a" ]
    #}
}

# SECURITY GROUP
# --------------

resource aws_security_group admin {
  name          = "admin"
  description   = "Admin EC2 instance security group"
  vpc_id        = data.aws_vpc.my_vpc.id

  ingress {
    description = "SSH from my own IP address"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = [var.my_own_ip_address]
  }

  ingress {
    description = "ICMP from my own IP address"
    protocol    = "icmp"
    from_port   = -1
    to_port     = -1
    cidr_blocks = [var.my_own_ip_address]
  }  

  egress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
      "Name" = "admin"
  }
}

# vpc
data aws_vpc my_vpc {
  tags = {
    "Name" = var.vpc_name
  }
}



# INSTANCE PROFILE
# ----------------

# instance profile
resource aws_iam_instance_profile admin {
  name      = "admin"
  role      = aws_iam_role.admin.name
}

# iam role
resource aws_iam_role admin {
  name               = "admin"
  description        = "Admin EC2 instance IAM role"
  assume_role_policy = file("${path.module}/files/ec2-trust.json")

  tags = {
      "Name" = "admin"
  }
}

# iam policy
resource aws_iam_role_policy_attachment admin {
  role       = aws_iam_role.admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
