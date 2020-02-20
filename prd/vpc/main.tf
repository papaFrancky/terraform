# dev/vpc/main.tf
# ---------------


module vpc {
  source = "../../modules/vpc"

  env    = "prd"
}
