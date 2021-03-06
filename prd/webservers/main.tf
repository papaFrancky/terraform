# dev/webservers/main.tf
# ----------------------


module webservers {
  source         = "../../modules/webservers"

  env            = "prd"
  instance_type  = "t3.small"
  nb_servers_min = 4
  nb_servers_max = 10
  use_prod_cname = false
  sns_topic      = "codeascode-webservers-prd"
}
