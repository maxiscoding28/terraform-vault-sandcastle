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
  type = string
}
variable "security_group_id" {
  type = string
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
variable "vpc_zone_identifier" {
  type = list(string)
}
variable "desired_capacity" {
  type = number
  default = 1
}
variable "max_size" {
  type = number
  default = 5
}
variable "min_size" {
  type = number
  default = 0
}