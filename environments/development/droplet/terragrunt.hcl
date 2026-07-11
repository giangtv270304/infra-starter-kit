include "root" {
  path = find_in_parent_folders("terragrunt.hcl")
}

locals {
  env_vars     = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  name         = local.env_vars.locals.name
  env          = local.env_vars.locals.env
  region       = local.env_vars.locals.region
  droplet_size = local.env_vars.locals.droplet_size
}

terraform {
  source = "${get_repo_root()}/modules/droplet"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  name         = "${local.name}-${local.env}-droplet"
  region       = local.region
  size         = local.droplet_size
  ssh_key_name = get_env("SSH_KEY_NAME", "gitops-deploy")
  vpc_id       = dependency.vpc.outputs.id
}
