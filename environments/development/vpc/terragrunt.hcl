include "root" {
  path = find_in_parent_folders("terragrunt.hcl")
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  name     = local.env_vars.locals.name
  env      = local.env_vars.locals.env
  region   = local.env_vars.locals.region
}

terraform {
  source = "${get_repo_root()}/modules/vpc"
}

inputs = {
  name     = "${local.name}-${local.env}-vpc"
  ip_range = "10.0.0.0/16"
  region   = local.region
}
