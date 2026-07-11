resource "digitalocean_database_cluster" "this" {
  name                 = "${var.name}-valkey"
  engine               = "valkey"
  version              = "8"
  size                 = var.size
  region               = var.region
  node_count           = var.node_count
  private_network_uuid = var.vpc_id
}

resource "digitalocean_database_firewall" "this" {
  cluster_id = digitalocean_database_cluster.this.id

  rule {
    type  = "tag"
    value = "gitops"
  }
}
