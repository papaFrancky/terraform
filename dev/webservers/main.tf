# dev/webservers/main.tf
# ---------------


module "webservers" {
  source         = "../../modules/webservers"

  env            = "dev"
  nb_servers_min = 1
  nb_servers_max = 1
}