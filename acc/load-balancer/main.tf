# dev/load-balancer/main.tf


module "load-balancer" {
  source = "../../modules/load-balancer"
  env    = "acc"
}
