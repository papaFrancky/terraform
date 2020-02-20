# dev/webservers/main.tf
# ----------------------


module webservers {
  source         = "../../modules/webservers"

  env            = "acc"
  instance_type  = "t3.micro"
  nb_servers_min = 2
  nb_servers_max = 6
  use_prod_cname = false
  sns_topic      = "codeascode-webservers-acc"
}
