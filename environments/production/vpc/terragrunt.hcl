include "root" {
  path = find_in_parent_folders()
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  name     = local.env_vars.locals.name
  env      = local.env_vars.locals.env
  region   = local.env_vars.locals.region
}

terraform {
  source = "../../../modules/vpc"
}

inputs = {
  name   = "${local.name}-${local.env}-vpc"
  region = local.region
}
