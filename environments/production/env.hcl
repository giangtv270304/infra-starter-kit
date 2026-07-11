locals {
  name = "gitops"
  env          = "production"
  region       = "sgp1"
  droplet_size = "s-2vcpu-2gb"
  db_size      = "db-s-1vcpu-1gb"
  volume_size  = 20 //GB
}
