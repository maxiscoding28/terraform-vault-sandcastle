locals {
  enable_consul = var.consul_mode != "none"
}

resource "aws_vpc_security_group_ingress_rule" "consul_sandcastle_http_local" {
  count             = local.enable_consul ? 1 : 0
  depends_on        = [data.http.get_local_ip]
  security_group_id = aws_security_group.vault_sandcastle.id
  cidr_ipv4         = "${chomp(data.http.get_local_ip.response_body)}/32"
  from_port         = 8500
  ip_protocol       = "tcp"
  to_port           = 8500
}

resource "aws_vpc_security_group_ingress_rule" "consul_sandcastle_http_intra_cluster" {
  count                        = local.enable_consul ? 1 : 0
  referenced_security_group_id = aws_security_group.vault_sandcastle.id
  security_group_id            = aws_security_group.vault_sandcastle.id
  from_port                    = 8300
  ip_protocol                  = "tcp"
  to_port                      = 8300
}

resource "aws_vpc_security_group_ingress_rule" "consul_sandcastle_lan_tcp" {
  count                        = local.enable_consul ? 1 : 0
  security_group_id            = aws_security_group.vault_sandcastle.id
  referenced_security_group_id = aws_security_group.vault_sandcastle.id
  from_port                    = 8301
  ip_protocol                  = "tcp"
  to_port                      = 8301
}

resource "aws_vpc_security_group_ingress_rule" "consul_sandcastle_lan_udp" {
  count                        = local.enable_consul ? 1 : 0
  security_group_id            = aws_security_group.vault_sandcastle.id
  referenced_security_group_id = aws_security_group.vault_sandcastle.id
  from_port                    = 8301
  ip_protocol                  = "udp"
  to_port                      = 8301
}

resource "aws_vpc_security_group_ingress_rule" "consul_sandcastle_lan_udp_local" {
  count             = local.enable_consul ? 1 : 0
  depends_on        = [data.http.get_local_ip]
  security_group_id = aws_security_group.vault_sandcastle.id
  cidr_ipv4         = "${chomp(data.http.get_local_ip.response_body)}/32"
  from_port         = 8301
  ip_protocol       = "udp"
  to_port           = 8301
}

resource "aws_vpc_security_group_ingress_rule" "consul_sandcastle_dns_tcp_local" {
  count             = local.enable_consul ? 1 : 0
  depends_on        = [data.http.get_local_ip]
  security_group_id = aws_security_group.vault_sandcastle.id
  cidr_ipv4         = "${chomp(data.http.get_local_ip.response_body)}/32"
  from_port         = 8600
  ip_protocol       = "tcp"
  to_port           = 8600
}

resource "aws_vpc_security_group_ingress_rule" "consul_sandcastle_dns_udp" {
  count                        = local.enable_consul ? 1 : 0
  security_group_id            = aws_security_group.vault_sandcastle.id
  referenced_security_group_id = aws_security_group.vault_sandcastle.id
  from_port                    = 8600
  ip_protocol                  = "udp"
  to_port                      = 8600
}