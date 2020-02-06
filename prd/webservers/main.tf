# prd/webservers/main.tf
# ---------------


module "webservers" {
  source         = "../../modules/webserver
  
  env            = "prd"
  instance_type  = "t2.micro"
  nb_servers_min = 1
  nb_servers_max = 3
  use_prod_cname = true
}
