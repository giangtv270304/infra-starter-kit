variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "size" {
  type    = string
  default = "db-s-1vcpu-1gb"
}

variable "node_count" {
  type    = number
  default = 1
}

variable "db_version" {
  type    = string
  default = "18"
}

variable "vpc_id" {
  type = string
}
