data "aws_ami" "consul_sandcastle" {
  count       = var.consul_mode ? 1 : 0
  most_recent = var.most_recent_ami
  owners      = var.ami_owners
  filter {
    name   = "name"
    values = var.ami_name_filters
  }
}
resource "aws_iam_role" "consul_sandcastle" {
  count = var.consul_mode ? 1 : 0
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}
resource "aws_iam_policy" "consul_sandcastle_kms_seal" {
  count = var.consul_mode ? 1 : 0
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
resource "aws_iam_policy" "consul_sandcastle_auto_join" {
  count = var.consul_mode ? 1 : 0
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:DescribeInstances"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
resource "aws_iam_role_policy_attachment" "consul_sandcastle_kms_seal" {
  count      = var.consul_mode ? 1 : 0
  role       = aws_iam_role.consul_sandcastle[0].name
  policy_arn = aws_iam_policy.consul_sandcastle_kms_seal[0].arn
}
resource "aws_iam_role_policy_attachment" "consul_sandcastle_auto_join" {
  count      = var.consul_mode ? 1 : 0
  role       = aws_iam_role.consul_sandcastle[0].name
  policy_arn = aws_iam_policy.consul_sandcastle_auto_join[0].arn
}
resource "aws_iam_instance_profile" "consul_sandcastle" {
  count = var.consul_mode ? 1 : 0
  role  = aws_iam_role.consul_sandcastle[0].name
}

resource "aws_launch_template" "consul_sandcastle" {
  count                  = var.consul_mode ? 1 : 0
  image_id               = data.aws_ami.consul_sandcastle[0].id
  instance_type          = var.instance_type
  key_name               = var.ec2_key_pair_name
  vpc_security_group_ids = [var.security_group_id]
  user_data = base64encode(templatefile("${path.module}/bootstrap-consul.sh", {
    consul_version   = var.consul_version
    desired_capacity = var.desired_capacity
  }))
  iam_instance_profile { name = aws_iam_instance_profile.consul_sandcastle[0].id }

}
resource "aws_autoscaling_group" "consul_sandcastle" {
  count               = var.consul_mode ? 1 : 0
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = var.vpc_zone_identifier
  launch_template {
    id      = aws_launch_template.consul_sandcastle[0].id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "consul-sandcastle"
    propagate_at_launch = true
  }
  tag {
    key                 = "join"
    value               = "consul-primary"
    propagate_at_launch = true
  }
}