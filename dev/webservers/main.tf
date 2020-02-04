# dev/webservers/main.tf
# ----------------------


module webservers {
  source         = "../../modules/webservers"

  env            = "dev"
  instance_type  = "t2.nano"
  nb_servers_min = 2
  nb_servers_max = 3
  use_prod_cname = false
}
