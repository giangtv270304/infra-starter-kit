include "root" {
  path = find_in_parent_folders()
}

locals {
  env_vars     = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env          = local.env_vars.locals.env
  name     = local.env_vars.locals.name
  region       = local.env_vars.locals.region
  droplet_size = local.env_vars.locals.droplet_size
}

terraform {
  source = "../../../modules/droplet"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  name   = "${local.name}-${local.env}-droplet"
  region       = local.region
  size         = local.droplet_size
  ssh_key_name = get_env("SSH_KEY_NAME", "gitops-deploy")
  vpc_id       = dependency.vpc.outputs.id
}
