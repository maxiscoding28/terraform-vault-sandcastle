output "target_group_arns" {
  value = var.create_secondary_cluster ? [aws_lb_target_group.vault_sandcastle[0].arn, aws_lb_target_group.vault_sandcastle[1].arn] : [aws_lb_target_group.vault_sandcastle[0].arn]
}