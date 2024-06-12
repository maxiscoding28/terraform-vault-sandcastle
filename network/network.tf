resource "aws_vpc" "vault_sandcastle" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
}
resource "aws_subnet" "vault_sandcastle_a" {
  vpc_id                  = aws_vpc.vault_sandcastle.id
  cidr_block              = var.subnet_a_cidr_block
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = "us-west-2a"
}
resource "aws_subnet" "vault_sandcastle_b" {
  vpc_id                  = aws_vpc.vault_sandcastle.id
  cidr_block              = var.subnet_b_cidr_block
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = "us-west-2b"

}
resource "aws_route_table_association" "vault_sandcastle_a" {
  subnet_id      = aws_subnet.vault_sandcastle_a.id
  route_table_id = aws_vpc.vault_sandcastle.main_route_table_id
}
resource "aws_route_table_association" "vault_sandcastle_b" {
  subnet_id      = aws_subnet.vault_sandcastle_b.id
  route_table_id = aws_vpc.vault_sandcastle.main_route_table_id
}
resource "aws_internet_gateway" "vault_sandcastle" {
  vpc_id = aws_vpc.vault_sandcastle.id
}
resource "aws_route" "vault_sandcastle" {
  route_table_id            = aws_vpc.vault_sandcastle.main_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.vault_sandcastle.id
}