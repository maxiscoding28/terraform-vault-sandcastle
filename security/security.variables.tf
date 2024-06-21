variable "network_vpc_id" {
  type = string
}
variable "vault_api_port" {
  type    = number
  default = 8200
}
variable "vault_cluster_port" {
  type    = number
  default = 8201
}
variable "load_balancer_port" {
  type    = number
  default = 80
}
variable "create_load_balancer" {
  type = bool
}
variable "consul_mode" {
  type = bool
}