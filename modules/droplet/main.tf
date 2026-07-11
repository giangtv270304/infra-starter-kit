data "digitalocean_ssh_key" "this" {
  name = var.ssh_key_name
}

resource "digitalocean_droplet" "this" {
  name     = var.name
  region   = var.region
  size     = var.size
  image    = "ubuntu-22-04-x64"
  vpc_uuid = var.vpc_id
  ssh_keys = [data.digitalocean_ssh_key.this.id]
  tags     = concat(["gitops"], var.tags)
}

resource "digitalocean_firewall" "this" {
  name        = var.name
  droplet_ids = [digitalocean_droplet.this.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "8080"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
