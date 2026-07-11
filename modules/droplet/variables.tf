variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "size" {
  type = string
}

variable "ssh_key_name" {
  type = string
}

variable "tags" {
  type    = list(string)
  default = []
}

variable "vpc_id" {
  type = string
}
