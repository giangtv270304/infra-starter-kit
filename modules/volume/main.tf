resource "digitalocean_volume" "this" {
  name   = "${var.name}-volume"
  region = var.region
  size   = var.size

  initial_filesystem_type = "ext4"
  description             = "Data volume for ${var.name}"
}

resource "digitalocean_volume_attachment" "this" {
  droplet_id = var.droplet_id
  volume_id  = digitalocean_volume.this.id
}
