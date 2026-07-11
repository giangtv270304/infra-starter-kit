include "root" {
  path = find_in_parent_folders()
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env      = local.env_vars.locals.env
  name     = local.env_vars.locals.name
  region   = local.env_vars.locals.region
  size     = local.env_vars.locals.db_size
}

terraform {
  source = "../../../modules/valkey"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  name   = "${local.name}-${local.env}-valkey"
  region = local.region
  size   = local.size
  vpc_id = dependency.vpc.outputs.id
}
