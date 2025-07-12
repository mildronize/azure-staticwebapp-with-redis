variable "prefix" {
  type    = string
  default = "demo-redis"
}
variable "location" {
  type    = string
  default = "southeastasia"
}
variable "redis_user" {
  type    = string
  default = "myuser"
}
variable "redis_pass" {
  type      = string
  sensitive = true
}

locals {
  rg_name     = "${var.prefix}-rg"
  vnet_name   = "aca-vnet"
  subnet_name = "demo-workload"
  env_name    = "redis-env"
  app_name    = "redis"
}
