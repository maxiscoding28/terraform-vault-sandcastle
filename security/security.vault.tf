resource "aws_security_group" "vault_sandcastle" {
  vpc_id = var.network_vpc_id
}
data "http" "get_local_ip" {
  url = "https://ipv4.icanhazip.com"
}
resource "aws_vpc_security_group_ingress_rule" "vault_sandcastle_ssh" {
  depends_on        = [data.http.get_local_ip]
  security_group_id = aws_security_group.vault_sandcastle.id
  cidr_ipv4         = "${chomp(data.http.get_local_ip.response_body)}/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_ingress_rule" "vault_sandcastle_vault_local" {
  depends_on        = [data.http.get_local_ip]
  security_group_id = aws_security_group.vault_sandcastle.id
  cidr_ipv4         = "${chomp(data.http.get_local_ip.response_body)}/32"
  from_port         = var.vault_api_port
  ip_protocol       = "tcp"
  to_port           = var.vault_api_port
}
resource "aws_vpc_security_group_ingress_rule" "vault_sandcastle_intra_cluster" {
  security_group_id            = aws_security_group.vault_sandcastle.id
  referenced_security_group_id = aws_security_group.vault_sandcastle.id
  from_port                    = var.vault_api_port
  ip_protocol                  = "tcp"
  to_port                      = var.vault_cluster_port
}
resource "aws_vpc_security_group_egress_rule" "vault_sandcastle_intra_cluster" {
  security_group_id            = aws_security_group.vault_sandcastle.id
  referenced_security_group_id = aws_security_group.vault_sandcastle.id
  from_port                    = var.vault_api_port
  ip_protocol                  = "tcp"
  to_port                      = var.vault_cluster_port
}
resource "aws_vpc_security_group_egress_rule" "vault_sandcastle_allow_all" {
  security_group_id = aws_security_group.vault_sandcastle.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
resource "aws_vpc_security_group_ingress_rule" "vault_sandcastle_local_to_load_balancer" {
  count             = var.create_load_balancer ? 1 : 0
  depends_on        = [data.http.get_local_ip]
  security_group_id = aws_security_group.vault_sandcastle.id
  cidr_ipv4         = "${chomp(data.http.get_local_ip.response_body)}/32"
  ip_protocol       = "tcp"
  from_port         = var.load_balancer_port
  to_port           = var.load_balancer_port
}
resource "aws_vpc_security_group_ingress_rule" "vault_sandcastle_load_balancer_to_vault" {
  count                        = var.create_load_balancer ? 1 : 0
  security_group_id            = aws_security_group.vault_sandcastle.id
  referenced_security_group_id = aws_security_group.vault_sandcastle.id
  ip_protocol                  = "tcp"
  from_port                    = var.vault_api_port
  to_port                      = var.vault_api_port
}