data "http" "get_local_ip" {
  url = "https://ipv4.icanhazip.com"
}
resource "aws_vpc_security_group_ingress_rule" "consul_vault_sandcastle_lan_serf_tcp" {
  count = var.consul_mode ? 1 : 0
  referenced_security_group_id = aws_security_group.consul_sandcastle[0].id
  security_group_id            = aws_security_group.vault_sandcastle.id
  from_port                    = 8301
  ip_protocol                  = "tcp"
  to_port                      = 8301
}
resource "aws_vpc_security_group_ingress_rule" "vault_consul_sandcastle_lan_serf_tcp" {
  count = var.consul_mode ? 1 : 0
  referenced_security_group_id = aws_security_group.vault_sandcastle.id
  security_group_id            = aws_security_group.consul_sandcastle[0].id
  from_port                    = 8301
  ip_protocol                  = "tcp"
  to_port                      = 8301
}
resource "aws_vpc_security_group_ingress_rule" "consul_vault_sandcastle_lan_serf_udp" {
  count = var.consul_mode ? 1 : 0
  referenced_security_group_id = aws_security_group.consul_sandcastle[0].id
  security_group_id            = aws_security_group.vault_sandcastle.id
  from_port                    = 8301
  ip_protocol                  = "udp"
  to_port                      = 8301
}
resource "aws_vpc_security_group_ingress_rule" "vault_consul_sandcastle_lan_serf_udp" {
  count = var.consul_mode ? 1 : 0
  referenced_security_group_id = aws_security_group.vault_sandcastle.id
  security_group_id            = aws_security_group.consul_sandcastle[0].id
  from_port                    = 8301
  ip_protocol                  = "udp"
  to_port                      = 8301
}
