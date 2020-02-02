# modules/admin-ec2-instance/outputs.tf

output instance_name {
  value = "${var.env}-admin"
}

output instance_id {
  value = aws_instance.admin.id
}

output public_ip {
  value = aws_instance.admin.public_ip
}

output ami_name {
  value = data.aws_ami.amazon_latest.name
}

output public_subnet_id {
  value = data.aws_subnet.public_subnet.id
}

