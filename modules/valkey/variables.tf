variable "name" {
  type = string
}

variable "size" {
  type = string
}

variable "region" {
  type = string
}

variable "node_count" {
  type    = number
  default = 1
}

variable "vpc_id" {
  type = string
}
