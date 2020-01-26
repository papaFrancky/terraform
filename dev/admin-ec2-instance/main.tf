# dev/admin-ec2-instance/main.tf


module "admin-ec2-instance" {
  source                 = "../../modules/admin-ec2-instance"
  env                    = "dev"
  my_own_ip_address = "88.191.67.129/32"
}
