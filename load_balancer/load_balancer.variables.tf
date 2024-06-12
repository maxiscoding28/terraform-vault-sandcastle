variable "load_balancer_type" {
  type    = string
  default = "application"
}
variable "subnets" {
  type    = list(string)
  default = []
}
variable "security_groups" {
  type    = list(string)
  default = []
}
variable "target_group_port" {
  type    = string
  default = "8200"
}
variable "target_group_protocol" {
  type    = string
  default = "HTTP"
}
variable "target_group_health_check_path" {
  type    = string
  default = "/v1/sys/health"
}
variable "target_group_health_check_codes" {
  type    = string
  default = "200,473"
}
variable "vpc_id" {
  type    = string
  default = ""
}
variable "listener_port" {
  type    = string
  default = "80"
}
variable "listener_protocol" {
  type    = string
  default = "HTTP"
}
variable "create_secondary_cluster" {
  type    = bool
  default = false
}