resource "aws_lb" "vault_sandcastle" {
  count              = var.create_secondary_cluster ? 2 : 1
  load_balancer_type = var.load_balancer_type
  subnets            = var.subnets
  security_groups    = var.security_groups
}
resource "aws_lb_target_group" "vault_sandcastle" {
  count    = var.create_secondary_cluster ? 2 : 1
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id
  health_check {
    path    = var.target_group_health_check_path
    matcher = var.target_group_health_check_codes
  }
}
resource "aws_lb_listener" "vault_sandcastle" {
  count             = var.create_secondary_cluster ? 2 : 1
  load_balancer_arn = aws_lb.vault_sandcastle[count.index].arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vault_sandcastle[count.index].arn
  }
}