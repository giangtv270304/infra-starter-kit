download_dir = "${get_parent_terragrunt_dir()}/.terragrunt-cache"

locals {
  path_parts = compact(split("/", path_relative_to_include()))
  stack      = reverse(local.path_parts)[0]

  storage_bucket = get_env("STORAGE_BUCKET", "learn-infrastructure-dev")
  storage_key    = "${local.stack}/terraform.tfstate"
  region         = get_env("DO_REGION", "sgp1")

  do_token   = get_env("DO_TOKEN")
  access_key = get_env("AWS_ACCESS_KEY_ID")
  secret_key = get_env("AWS_SECRET_ACCESS_KEY")
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
  provider "digitalocean" {
    token = "${local.do_token}"
  }
  EOF
}

remote_state {
  backend = "s3"
  config = {
    endpoint = "https://sgp1.digitaloceanspaces.com"
    bucket   = local.storage_bucket
    key      = local.storage_key
    region   = local.region

    access_key = local.access_key
    secret_key = local.secret_key

    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    use_path_style              = true
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
}

