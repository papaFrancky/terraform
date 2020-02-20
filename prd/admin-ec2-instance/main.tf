# dev/admin-ec2-instance/main.tf


module "admin-ec2-instance" {
  source            = "../../modules/admin-ec2-instance"
  env               = "prd"
  my_own_ip_address = "<my_own_ip_address>/32"
}
