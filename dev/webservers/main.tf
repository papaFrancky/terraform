# dev/webservers/main.tf
# ----------------------


module webservers {
  source         = "../../modules/webservers"

  env            = "dev"
  instance_type  = "t2.micro"
  nb_servers_min = 2
  nb_servers_max = 6
  use_prod_cname = false
}
