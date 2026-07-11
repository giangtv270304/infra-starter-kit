output "id" {
  value = digitalocean_volume.this.id
}

output "urn" {
  value = digitalocean_volume.this.urn
}

output "mount_path" {
  value = "/mnt/gitops-${var.name}-data"
}
