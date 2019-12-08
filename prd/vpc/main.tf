# prd/vpc/main.tf
# ---------------


module "vpc" {
  source = "../../modules/vpc"

  env    = "prd"
}


# OUTPUT VARIABLES
# ----------------

output "region" {
  value   = module.vpc.region
}

output "env" {
  value   = module.vpc.env
}

output "vpc_id" {
  value   = module.vpc.vpc_id
}

output "public_subnets_ids" {
    value = module.vpc.public_subnets_ids
}

output "public_subnets_names" {
  value   = module.vpc.public_subnets_names
}

output "public_cidrs" {
    value = module.vpc.public_cidrs
}

#output "private_subnets_ids" {
#    value = module.vpc.private_subnets_ids
#}

#output "private_subnets_names" {
#  value   = module.vpc.private_subnets_names
#}

#output "private_cidrs" {
#    value = module.vpc.private_cidrs
#}

