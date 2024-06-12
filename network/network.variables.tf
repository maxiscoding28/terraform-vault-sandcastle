variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}
variable "enable_dns_hostnames" {
  type    = bool
  default = true
}
variable "subnet_a_cidr_block" {
  type    = string
  default = "10.0.1.0/24"
}
variable "subnet_b_cidr_block" {
  type    = string
  default = "10.0.2.0/24"
}
variable "map_public_ip_on_launch" {
  type    = bool
  default = true
}