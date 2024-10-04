module "network" {
  source                  = "./network"
  vpc_cidr_block          = var.vpc_cidr_block
  enable_dns_hostnames    = var.enable_dns_hostnames
  subnet_a_cidr_block     = var.subnet_a_cidr_block
  subnet_b_cidr_block     = var.subnet_b_cidr_block
  map_public_ip_on_launch = var.map_public_ip_on_launch
}
module "security" {
  source               = "./security"
  network_vpc_id       = module.network.vpc_id
  create_load_balancer = var.create_load_balancer
  consul_mode          = var.consul_mode
}
module "servers" {
  source                   = "./servers"
  security_group_id        = module.security.security_group_id
  vpc_zone_identifier      = module.network.subnets
  ec2_key_pair_name        = var.ec2_key_pair_name
  desired_capacity         = var.desired_capacity
  bootstrap_vault          = var.bootstrap_vault
  iam_instance_profile     = module.iam.iam_instance_profile_id
  kms_key_arn              = module.kms.kms_arn
  target_group_arns        = var.create_load_balancer ? module.load_balancer[0].target_group_arns : []
  vault_license            = var.vault_license
  create_secondary_cluster = var.create_secondary_cluster
  most_recent_ami          = var.most_recent_ami
  ami_owners               = var.ami_owners
  ami_name_filters         = var.ami_name_filters
  instance_type            = var.instance_type
  vault_version            = var.vault_version
  max_size                 = var.max_size
  min_size                 = var.min_size
  server_name              = var.server_name
  consul_mode              = var.consul_mode
  consul_version           = var.consul_version
}
module "kms" {
  source                  = "./kms"
  deletion_window_in_days = var.deletion_window_in_days
}
module "iam" {
  source      = "./iam"
  kms_key_arn = module.kms.kms_arn
}
module "load_balancer" {
  count                           = var.create_load_balancer ? 1 : 0
  source                          = "./load_balancer"
  subnets                         = module.network.subnets
  security_groups                 = [module.security.security_group_id]
  vpc_id                          = module.network.vpc_id
  create_secondary_cluster        = var.create_secondary_cluster
  load_balancer_type              = var.load_balancer_type
  target_group_port               = var.target_group_port
  target_group_health_check_path  = var.target_group_health_check_path
  target_group_health_check_codes = var.target_group_health_check_codes
  target_group_protocol           = var.target_group_protocol
  listener_port                   = var.listener_port
  listener_protocol               = var.listener_protocol
  server_name                     = var.server_name
}
module "consul" {
  source                   = "./consul"
  most_recent_ami          = var.most_recent_ami
  ami_owners               = var.ami_owners
  ami_name_filters         = var.ami_name_filters
  instance_type            = var.instance_type
  ec2_key_pair_name        = var.ec2_key_pair_name
  desired_capacity         = var.desired_capacity
  max_size                 = var.max_size
  min_size                 = var.min_size
  consul_version           = var.consul_version
  server_name              = var.server_name
  vpc_zone_identifier      = module.network.subnets
  network_vpc_id           = module.network.vpc_id
  consul_mode              = var.consul_mode
  security_group_id        = module.security.security_group_id
  create_secondary_cluster = var.create_secondary_cluster
}