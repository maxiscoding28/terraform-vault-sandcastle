resource "aws_iam_role" "vault_sandcastle" {
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
resource "aws_iam_policy" "vault_sandcastle_kms_seal" {
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
resource "aws_iam_policy" "vault_sandcastle_auto_join" {
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
resource "aws_iam_role_policy_attachment" "vault_sandcastle_kms_seal" {
  role       = aws_iam_role.vault_sandcastle.name
  policy_arn = aws_iam_policy.vault_sandcastle_kms_seal.arn
}
resource "aws_iam_role_policy_attachment" "vault_sandcastle_auto_join" {
  role       = aws_iam_role.vault_sandcastle.name
  policy_arn = aws_iam_policy.vault_sandcastle_auto_join.arn
}
resource "aws_iam_instance_profile" "vault_sandcastle" {
  role = aws_iam_role.vault_sandcastle.name
}
