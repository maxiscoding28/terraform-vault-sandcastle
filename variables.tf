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
variable "kms_key_arn" {
  type    = string
  default = "*"
}
variable "deletion_window_in_days" {
  type    = number
  default = 7
}
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
  default = ""
}
variable "create_secondary_cluster" {
  type    = bool
  default = false
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
  type    = bool
  default = false
}
variable "most_recent_ami" {
  type    = bool
  default = true
}
variable "ami_owners" {
  type    = list(string)
  default = ["amazon"]
}
variable "ami_name_filters" {
  type    = list(string)
  default = ["al2023-ami-2023.4.20240611.0-kernel-6.1-x86_64"]
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "ec2_key_pair_name" {
  type    = string
  default = ""
}
variable "bootstrap_vault" {
  type    = bool
  default = true
}
variable "vault_version" {
  type    = string
  default = "1.16.0"
}
variable "vault_license" {
  type    = string
  default = ""
}
variable "desired_capacity" {
  type    = number
  default = 1
}
variable "max_size" {
  type    = number
  default = 5
}
variable "min_size" {
  type    = number
  default = 0
}
variable "target_group_arns" {
  type    = list(string)
  default = []
}
variable "server_name" {
  type    = list(string)
  default = ["primary", "secondary"]
}
variable "consul_mode" {
  type    = bool
  default = false
}
variable "consul_version" {
  type    = string
  default = "1.19.0"
}