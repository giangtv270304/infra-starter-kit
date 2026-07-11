variable "do_token" {
  type      = string
  sensitive = true
}

variable "env" {
  type    = string
  default = "dev"
}

variable "region" {
  type    = string
  default = "sgp1"
}

variable "droplet_size" {
  type    = string
  default = "s-1vcpu-1gb"
}

variable "ssh_key_name" {
  type = string
}
