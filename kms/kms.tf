resource "aws_kms_key" "vault_sandcastle" {
  deletion_window_in_days = var.deletion_window_in_days
}