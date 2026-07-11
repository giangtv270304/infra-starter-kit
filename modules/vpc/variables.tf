variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "ip_range" {
  type    = string
  default = "10.10.0.0/16"
}
