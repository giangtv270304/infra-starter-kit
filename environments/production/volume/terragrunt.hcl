include "root" {
  path = find_in_parent_folders()
}

locals {
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env         = local.env_vars.locals.env
  region      = local.env_vars.locals.region
  volume_size = local.env_vars.locals.volume_size
}

terraform {
  source = "../../../modules/volume"
}

dependency "droplet" {
  config_path = "../droplet"
}

inputs = {
name        = local.env_vars.locals.name
  region     = local.region
  size       = local.volume_size
  droplet_id = dependency.droplet.outputs.id
}
