# Vault Sandcastle
<p align="center">
<img src="https://github.com/maxiscoding28/terraform-vault-sandcastle/blob/main/logo.png">
</p>

## Quick Start
  - **Prequisites**:
    - Ensure you have credentials for an admin-like AWS user in the terminal shell where you will be running Terraform apply.
    - Run `aws sts get-caller-identity` to verify your AWS identity.

  - **Step 1**
    - From the project's root directory run `terraform init`.
    - Run `terraform apply`
    - Type `yes` and hit enter.
    - Retrieve the Public DNS name for the created EC2 instance:
      - _Via web ui:_ Navigate to EC2 page, select instance, copy the value for `Public IPv4 DNS`
      - _Via aws cli_: run the following command and copy the value for `b DNS NAME
        ```sh
        aws ec2 describe-instances \
        --filter Name=instance-state-name,Values=running \
        --output table \
        --query 'sort_by(Reservations[].Instances[].{NAME: Tags[?Key==`Name`].Value | [0], "DNS NAME": PublicDnsName, "INSTANCE ID": InstanceId}, &NAME)'
        ```
  - **Step 2**
    - Prepend `http://` to the public DNS name and append `:8200`.
    - Set this new value to shell env variable `VAULT_ADDR`
      - `export VAULT_ADDR=http://<Public DNS Name>:8200`

  - **Step 3**
    - Run `vault status`

# SSH-ing into an Instance
  - **Step 1**
    - Retrieve the name of the [EC2 key pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html) you use for SSH-ing into EC2 instances.

  - **Step 2**
    - In the project's root directory, create a file called `terraform.tfvars`.
    - Add your EC2 key pair name value as a variable called `ec2_key_pair_name`:
      - **terraform.tfvars**
        ```
        ec2_key_pair_name = "<Your EC2 key pair name>"
        ```
    - Run `terraform apply`
    - Type `yes` and hit enter.

  - **Step 3**
    - Once that completes, you should now be able to SSH in to the instance as either the `vault` user or `ec2-user` using the instance's public DNS and your EC2 key pair.
      - `ssh -i /Users/maxwinslow/.ssh/ec2/us-west-2.pem -A vault@<Public DNS Name>`
      - `ssh -i /Users/maxwinslow/.ssh/ec2/us-west-2.pem -A ec2-user@<Public DNS Name>`
        - **Note**: The vault user is only created when the Terraform variable `bootstrap_vault` is set to `true`. By default this variable is set to `true`. However, if set to false, the `vault` user is not created and therefore you cannot ssh into the instance as that user.
  
  - **Step 4**
    - Run `terraform apply`
    - Type `yes` and hit enter.


## Scale-in and Out
  - **Step 1**
    - Add your desired number of servers as a variable called `desired_capacity` in your `terraform.tfvars` file.
      - **terraform.tfvars**
        ```
        desired_capacity = <YOUR DESIRED # of servers>
        ```
  - **Step 2**
    - Run `terraform apply`
    - Type `yes` and hit enter.

## Versioning
  - **Step 1**
    - Add your desired vault version as a variable called `vault_version` in your `terraform.tfvars` file.
      - Syntax used is (as an example): `1.17.0`, `1.17.0+ent`
      - **terraform.tfvars**
        ```
        vault_version = "<YOUR DESIRED vault version>"
        ```
  - **Step 2**
    - Run `terraform apply`
    - Type `yes` and hit enter.
      - **Note**: Instances with the updated Vault version will only be created on *new* instances. It will not upgrade existing instances.

## Load Balancers
  - **Step 1**
    - Add a variable called `create_load_balancer` in your `terraform.tfvars` file and set it to `true`.
      - **terraform.tfvars**
        ```
        create_load_balancer = true
        ```
  - **Step 2**
    - Run `terraform apply`
    - Type `yes` and hit enter.
    - **Note**: You can change this to a network load balancer by setting the variable `load_balancer_type` to `network` (it is `application` by default).

## Replication
  - **Step 1**
    - Add a variable called `create_secondary_cluster` in your `terraform.tfvars` file and set it to `true`.
      - **terraform.tfvars**
        ```
        create_secondary_cluster = true
        ```
  - **Step 2**
    - Run `terraform apply`
    - Type `yes` and hit enter.

## Full Terraform Documentation (generated via [terraform-docs](https://terraform-docs.io/))

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam"></a> [iam](#module\_iam) | ./iam | n/a |
| <a name="module_kms"></a> [kms](#module\_kms) | ./kms | n/a |
| <a name="module_load_balancer"></a> [load\_balancer](#module\_load\_balancer) | ./load_balancer | n/a |
| <a name="module_network"></a> [network](#module\_network) | ./network | n/a |
| <a name="module_security"></a> [security](#module\_security) | ./security | n/a |
| <a name="module_servers"></a> [servers](#module\_servers) | ./servers | n/a |

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
