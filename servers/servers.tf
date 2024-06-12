data "aws_ami" "vault_sandcastle" {
  most_recent = var.most_recent_ami
  owners      = var.ami_owners
  filter {
    name   = "name"
    values = var.ami_name_filters
  }
}
resource "aws_launch_template" "vault_sandcastle" {
  image_id               = data.aws_ami.vault_sandcastle.id
  instance_type          = var.instance_type
  key_name               = var.ec2_key_pair_name
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile {
    name = var.iam_instance_profile
  }
  user_data = base64encode(templatefile("${path.module}/bootstrap-vault.sh", {
    vault_version = var.vault_version
    vault_license = var.vault_license
    kms_key_arn   = var.kms_key_arn
  }))
}
resource "aws_autoscaling_group" "vault_sandcastle" {
  vpc_zone_identifier = var.vpc_zone_identifier
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  launch_template {
    id      = aws_launch_template.vault_sandcastle.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "vault_sandcastle"
    propagate_at_launch = true
  }
}