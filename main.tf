module "network" {
  source = "./network"
}
module "security" {
  source               = "./security"
  network_vpc_id       = module.network.vpc_id
  create_load_balancer = var.create_load_balancer
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

}
module "kms" {
  source = "./kms"
}
module "iam" {
  source      = "./iam"
  kms_key_arn = module.kms.kms_arn
}
module "load_balancer" {
  count                    = var.create_load_balancer ? 1 : 0
  source                   = "./load_balancer"
  subnets                  = module.network.subnets
  security_groups          = [module.security.security_group_id]
  vpc_id                   = module.network.vpc_id
  create_secondary_cluster = var.create_secondary_cluster
}