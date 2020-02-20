# dev/admin-ec2-instance/outputs.tf


output instance_name {
  value = module.admin-ec2-instance.instance_name
}

output instance_id {
  value = module.admin-ec2-instance.instance_id
}

output ami_name {
  value = module.admin-ec2-instance.ami_name
}

output public_ip {
  value = module.admin-ec2-instance.public_ip
}

output public_subnet_id {
  value = module.admin-ec2-instance.public_subnet_id 
}
