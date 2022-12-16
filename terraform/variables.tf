variable "key" {
  sensitive = true
}
variable "secret" {
  sensitive = true
}

variable "zone" {
  type    = string
  default = "at-vie-1"
}

variable "nodepool_enabled" {
  type    = bool
  default = true
}