output "id" {
  value = digitalocean_database_cluster.this.id
}

output "host" {
  value = digitalocean_database_cluster.this.private_host
}

output "port" {
  value = digitalocean_database_cluster.this.port
}

output "database" {
  value = digitalocean_database_cluster.this.database
}

output "username" {
  value = digitalocean_database_cluster.this.user
}

output "password" {
  value     = digitalocean_database_cluster.this.password
  sensitive = true
}

output "uri" {
  value     = digitalocean_database_cluster.this.uri
  sensitive = true
}
