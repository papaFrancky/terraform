# dev/vpc/main.tf
# ---------------


output region {
  value   = module.vpc.region
}

output env {
  value   = module.vpc.env
}

output vpc_id {
  value   = module.vpc.vpc_id
}

output public_subnets_ids {
    value = module.vpc.public_subnets_ids
}

output public_subnets_names {
  value   = module.vpc.public_subnets_names
}

output public_cidrs {
    value = module.vpc.public_cidrs
}
