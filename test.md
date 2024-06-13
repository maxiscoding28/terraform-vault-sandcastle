## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam"></a> [iam](#module\_iam) | ./iam | n/a |
| <a name="module_kms"></a> [kms](#module\_kms) | ./kms | n/a |
| <a name="module_load_balancer"></a> [load\_balancer](#module\_load\_balancer) | ./load_balancer | n/a |
| <a name="module_network"></a> [network](#module\_network) | ./network | n/a |
| <a name="module_security"></a> [security](#module\_security) | ./security | n/a |
| <a name="module_servers"></a> [servers](#module\_servers) | ./servers | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_name_filters"></a> [ami\_name\_filters](#input\_ami\_name\_filters) | n/a | `list(string)` | <pre>[<br>  "al2023-ami-2023.4.20240611.0-kernel-6.1-x86_64"<br>]</pre> | no |
| <a name="input_ami_owners"></a> [ami\_owners](#input\_ami\_owners) | n/a | `list(string)` | <pre>[<br>  "amazon"<br>]</pre> | no |
| <a name="input_bootstrap_vault"></a> [bootstrap\_vault](#input\_bootstrap\_vault) | n/a | `bool` | `true` | no |
| <a name="input_create_load_balancer"></a> [create\_load\_balancer](#input\_create\_load\_balancer) | n/a | `bool` | `false` | no |
| <a name="input_create_secondary_cluster"></a> [create\_secondary\_cluster](#input\_create\_secondary\_cluster) | n/a | `bool` | `false` | no |
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | n/a | `number` | `7` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | n/a | `number` | `1` | no |
| <a name="input_ec2_key_pair_name"></a> [ec2\_key\_pair\_name](#input\_ec2\_key\_pair\_name) | n/a | `string` | `""` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | n/a | `bool` | `true` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | n/a | `string` | `"t2.micro"` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | n/a | `string` | `"*"` | no |
| <a name="input_listener_port"></a> [listener\_port](#input\_listener\_port) | n/a | `string` | `"80"` | no |
| <a name="input_listener_protocol"></a> [listener\_protocol](#input\_listener\_protocol) | n/a | `string` | `""` | no |
| <a name="input_load_balancer_port"></a> [load\_balancer\_port](#input\_load\_balancer\_port) | n/a | `number` | `80` | no |
| <a name="input_load_balancer_type"></a> [load\_balancer\_type](#input\_load\_balancer\_type) | n/a | `string` | `"application"` | no |
| <a name="input_map_public_ip_on_launch"></a> [map\_public\_ip\_on\_launch](#input\_map\_public\_ip\_on\_launch) | n/a | `bool` | `true` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | n/a | `number` | `5` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | n/a | `number` | `0` | no |
| <a name="input_most_recent_ami"></a> [most\_recent\_ami](#input\_most\_recent\_ami) | n/a | `bool` | `true` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | n/a | `list(string)` | `[]` | no |
| <a name="input_server_name"></a> [server\_name](#input\_server\_name) | n/a | `list(string)` | <pre>[<br>  "primary",<br>  "secondary"<br>]</pre> | no |
| <a name="input_subnet_a_cidr_block"></a> [subnet\_a\_cidr\_block](#input\_subnet\_a\_cidr\_block) | n/a | `string` | `"10.0.1.0/24"` | no |
| <a name="input_subnet_b_cidr_block"></a> [subnet\_b\_cidr\_block](#input\_subnet\_b\_cidr\_block) | n/a | `string` | `"10.0.2.0/24"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | n/a | `list(string)` | `[]` | no |
| <a name="input_target_group_arns"></a> [target\_group\_arns](#input\_target\_group\_arns) | n/a | `list(string)` | `[]` | no |
| <a name="input_target_group_health_check_codes"></a> [target\_group\_health\_check\_codes](#input\_target\_group\_health\_check\_codes) | n/a | `string` | `"200,473"` | no |
| <a name="input_target_group_health_check_path"></a> [target\_group\_health\_check\_path](#input\_target\_group\_health\_check\_path) | n/a | `string` | `"/v1/sys/health"` | no |
| <a name="input_target_group_port"></a> [target\_group\_port](#input\_target\_group\_port) | n/a | `string` | `"8200"` | no |
| <a name="input_target_group_protocol"></a> [target\_group\_protocol](#input\_target\_group\_protocol) | n/a | `string` | `"HTTP"` | no |
| <a name="input_vault_api_port"></a> [vault\_api\_port](#input\_vault\_api\_port) | n/a | `number` | `8200` | no |
| <a name="input_vault_cluster_port"></a> [vault\_cluster\_port](#input\_vault\_cluster\_port) | n/a | `number` | `8201` | no |
| <a name="input_vault_license"></a> [vault\_license](#input\_vault\_license) | n/a | `string` | `""` | no |
| <a name="input_vault_version"></a> [vault\_version](#input\_vault\_version) | n/a | `string` | `"1.16.0"` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | n/a | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | `""` | no |

## Outputs

No outputs.
