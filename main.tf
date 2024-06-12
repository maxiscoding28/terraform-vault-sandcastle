module "network" {
  source = "./network"
}
module "security" {
  source         = "./security"
  network_vpc_id = module.network.vpc_id
}
module "servers" {
  source              = "./servers"
  security_group_id   = module.security.security_group_id
  vpc_zone_identifier = module.network.subnets
  ec2_key_pair_name   = var.ec2_key_pair_name
  desired_capacity    = var.desired_capacity
  bootstrap_vault     = var.bootstrap_vault
}