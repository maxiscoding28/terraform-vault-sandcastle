output "vpc_id" {
  value = aws_vpc.vault_sandcastle.id
}
output "subnets" {
  value = [aws_subnet.vault_sandcastle_a.id, aws_subnet.vault_sandcastle_b.id]
}