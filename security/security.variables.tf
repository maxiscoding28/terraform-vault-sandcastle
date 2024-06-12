variable "network_vpc_id" {
  type = string
}
variable "vault_api_port" {
  type    = number
  default = 8200
}
variable "vault_cluster_port" {
  type    = number
  default = 8200
}