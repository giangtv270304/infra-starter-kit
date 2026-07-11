variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "size" {
  type    = number
  default = 10
}

variable "droplet_id" {
  type = string
}
