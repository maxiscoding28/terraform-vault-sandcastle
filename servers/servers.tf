data "aws_ami" "vault_sandcastle" {
  most_recent = var.most_recent_ami
  owners      = var.ami_owners
  filter {
    name   = "name"
    values = var.ami_name_filters
  }
}
resource "aws_launch_template" "vault_sandcastle" { 
  count                  = var.create_secondary_cluster ? 2 : 1
  image_id               = data.aws_ami.vault_sandcastle.id
  instance_type          = var.instance_type
  key_name               = var.ec2_key_pair_name
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile { name = var.iam_instance_profile }
  user_data = var.bootstrap_vault && ! var.consul_mode ? base64encode(templatefile("${path.module}/bootstrap-vault.sh", {
    vault_version = var.vault_version
    vault_license = var.vault_license
    kms_key_arn   = var.kms_key_arn
    server_name   = var.server_name[count.index]
  })) : var.bootstrap_vault && var.consul_mode ? base64encode(templatefile("${path.module}/bootstrap-vault-consul.sh", {
    vault_version = var.vault_version
    vault_license = var.vault_license
    kms_key_arn   = var.kms_key_arn
    server_name   = var.server_name[count.index]
    consul_version = var.consul_version
  })) : null
}
resource "aws_autoscaling_group" "vault_sandcastle" {
  count               = var.create_secondary_cluster ? 2 : 1
  vpc_zone_identifier = var.vpc_zone_identifier
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  target_group_arns   = length(var.target_group_arns) == 0 ? [] : [var.target_group_arns[count.index]]
  launch_template {
    id      = aws_launch_template.vault_sandcastle[count.index].id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "vault_sandcastle_${var.server_name[count.index]}"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group_tag" "vault_sandcastle" {
  count = var.consul_mode ? 1 : 0
  autoscaling_group_name = aws_autoscaling_group.vault_sandcastle[0].name
  tag {
    key = "join"
    value = "consul-primary"
    propagate_at_launch = true
  }
}