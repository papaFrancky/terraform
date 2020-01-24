# dev/webservers/main.tf
# ---------------


module "webservers" {
  source         = "../../modules/webservers"

  env            = "dev"
  nb_servers_min = 2
  nb_servers_max = 2
}



# OUTPUT VARIABLES
# ----------------

output "elb_dns_native_name" {
  value = module.webservers.elb_dns_native_name

  depends_on = [
    module.webservers.aws_elb.webservers
  ]
}

output "elb_dns_alias" {
  value = module.webservers.elb_dns_alias

  depends_on = [
    module.webservers.aws_elb.webservers
  ]
}

output "elb_instances" {
  value = module.webservers.elb_instances

  depends_on = [
    module.webservers.aws_elb.webservers
  ]
}
