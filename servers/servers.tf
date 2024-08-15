locals {
  bootstrap_raft_vault_primary = var.bootstrap_vault && (var.consul_mode == "none" || var.consul_mode == "secondary")
  bootstrap_raft_vault_secondary = var.bootstrap_vault && (var.consul_mode == "none" || var.consul_mode == "primary")
  bootstrap_consul_vault_primary = var.bootstrap_vault && (var.consul_mode == "both" || var.consul_mode == "primary")
  bootstrap_consul_vault_secondary = var.bootstrap_vault && (var.consul_mode == "both" || var.consul_mode == "secondary")
  launch_templates = [
    aws_launch_template.vault_sandcastle_primary.id,
    var.create_secondary_cluster ? aws_launch_template.vault_sandcastle_secondary[0].id : null
  ]
  consul_mode = var.consul_mode != "none"
}

data "aws_ami" "vault_sandcastle" {
  most_recent = var.most_recent_ami
  owners      = var.ami_owners
  filter {
    name   = "name"
    values = var.ami_name_filters
  }
}
resource "aws_launch_template" "vault_sandcastle_primary" {
  image_id               = data.aws_ami.vault_sandcastle.id
  instance_type          = var.instance_type
  key_name               = var.ec2_key_pair_name
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile { name = var.iam_instance_profile }
  user_data = local.bootstrap_raft_vault_primary ? base64encode(templatefile("${path.module}/bootstrap-vault.sh", {
    vault_version              = var.vault_version
    vault_license              = var.vault_license
    kms_key_arn                = var.kms_key_arn
    server_name                = var.server_name[0]
    })) : local.bootstrap_consul_vault_primary ? base64encode(templatefile("${path.module}/bootstrap-vault-consul.sh", {
    vault_version              = var.vault_version
    vault_license              = var.vault_license
    kms_key_arn                = var.kms_key_arn
    server_name                = var.server_name[0]
    consul_version             = var.consul_version

  })) : null
}
resource "aws_launch_template" "vault_sandcastle_secondary" {
  count                  = var.create_secondary_cluster ? 1 : 0
  image_id               = data.aws_ami.vault_sandcastle.id
  instance_type          = var.instance_type
  key_name               = var.ec2_key_pair_name
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile { name = var.iam_instance_profile }
  user_data = local.bootstrap_raft_vault_secondary ? base64encode(templatefile("${path.module}/bootstrap-vault.sh", {
    vault_version              = var.vault_version
    vault_license              = var.vault_license
    kms_key_arn                = var.kms_key_arn
    server_name                = var.server_name[1]
    })) : local.bootstrap_consul_vault_secondary ? base64encode(templatefile("${path.module}/bootstrap-vault-consul.sh", {
    vault_version              = var.vault_version
    vault_license              = var.vault_license
    kms_key_arn                = var.kms_key_arn
    server_name                = var.server_name[1]
    consul_version             = var.consul_version

  })) : null
}
resource "aws_autoscaling_group" "vault_sandcastle_primary" {
  vpc_zone_identifier = var.vpc_zone_identifier
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  target_group_arns   = length(var.target_group_arns) == 0 ? [] : [var.target_group_arns[0]]
  launch_template {
    id      = local.launch_templates[0]
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = local.bootstrap_consul_vault_primary ? "vault_sandcastle_consul_${var.server_name[0]}" : "vault_sandcastle_${var.server_name[0]}"
    propagate_at_launch = true
  }

    tag {
    key                 = "join"
    value               = "consul-${var.server_name[0]}"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "vault_sandcastle_secondary" {
  count               = var.create_secondary_cluster ? 1 : 0
  vpc_zone_identifier = var.vpc_zone_identifier
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  target_group_arns   = length(var.target_group_arns) == 2 ? [var.target_group_arns[1]] : []
  launch_template {
    id      = local.launch_templates[1]
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = local.bootstrap_consul_vault_secondary ? "vault_sandcastle_consul_${var.server_name[1]}" : "vault_sandcastle_${var.server_name[1]}"
    propagate_at_launch = true
  }

  tag {
    key                 = "join"
    value               = "consul-${var.server_name[1]}"
    propagate_at_launch = true
  }
}