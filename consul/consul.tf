data "aws_ami" "consul_sandcastle" {
  most_recent = var.most_recent_ami
  owners      = var.ami_owners
  filter {
    name   = "name"
    values = var.ami_name_filters
  }
}
resource "aws_iam_role" "consul_sandcastle" {
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
  role       = aws_iam_role.consul_sandcastle.name
  policy_arn = aws_iam_policy.consul_sandcastle_kms_seal.arn
}
resource "aws_iam_role_policy_attachment" "consul_sandcastle_auto_join" {
  role       = aws_iam_role.consul_sandcastle.name
  policy_arn = aws_iam_policy.consul_sandcastle_auto_join.arn
}
resource "aws_iam_instance_profile" "consul_sandcastle" {
  role = aws_iam_role.consul_sandcastle.name
}

resource "aws_launch_template" "consul_sandcastle" {
  image_id               = data.aws_ami.consul_sandcastle.id
  instance_type          = var.instance_type
  key_name               = var.ec2_key_pair_name
  vpc_security_group_ids = [var.security_group_id]
  user_data = base64encode(templatefile("${path.module}/bootstrap-consul.sh", {
    consul_version   = var.consul_version
    desired_capacity = var.desired_capacity
  }))
  iam_instance_profile { name = aws_iam_instance_profile.consul_sandcastle.id }

}
resource "aws_autoscaling_group" "consul_sandcastle" {
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = var.vpc_zone_identifier
  launch_template {
    id      = aws_launch_template.consul_sandcastle.id
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