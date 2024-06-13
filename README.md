# Vault Sandcastle
<p align="center">
<img src="./logo.png">
</p>
## Quick Start
  - ### Prequisites:
    - Ensure you have credentials for an admin-like AWS user in the terminal shell where you will be running Terraform apply.
    - Run `aws sts get-caller-identity` to verify your AWS identity.

  - ### Step 1
    - From the project's root directory, run `terraform apply`
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
  - ### Step 2
    - Prepend `http://` to the public DNS name and append `:8200`.
    - Set this new value to shell env variable `VAULT_ADDR`
      - `export VAULT_ADDR=http://<Public DNS Name>:8200`

  - ### Step 3
    - Run `vault status`

# SSH-ing into an Instance
  - ### Step 1
    - Retrieve the name of the [EC2 key pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html) you use for SSH-ing into EC2 instances.

  - ### Step 2
    - In the project's root directory, create a file called `terraform.tfvars`.
    - Add your EC2 key pair name value as a variable called `ec2_key_pair_name`:
      - **terraform.tfvars**
        ```
        ec2_key_pair_name = "<Your EC2 key pair name>"
        ```
    - Run `terraform apply`
    - Type `yes` and hit enter.

  - ### Step 3
    - Once that completes, you should now be able to SSH in to the instance as either the `vault` user or `ec2-user` using the instance's public DNS and your EC2 key pair.
      - `ssh -i /Users/maxwinslow/.ssh/ec2/us-west-2.pem -A vault@<Public DNS Name>`
      - `ssh -i /Users/maxwinslow/.ssh/ec2/us-west-2.pem -A ec2-user@<Public DNS Name>`
        - **Note**: The vault user is only created when the Terraform variable `bootstrap_vault` is set to `true`. By default this variable is set to `true`. However, if set to false, the `vault` user is not created and therefore you cannot ssh into the instance as that user.
  
  - ### Step 4
    - Run `terraform apply`
    - Type `yes` and hit enter.


## Scale-in and Out
  - ### Step 1
    - Add your desired number of servers as a variable called `desired_capacity` in your `terraform.tfvars` file.
      - **terraform.tfvars**
        ```
        desired_capacity = <YOUR DESIRED # of servers>
        ```
  - ### Step 2
    - Run `terraform apply`
    - Type `yes` and hit enter.

## Versioning
  - ### Step 1
    - Add your desired vault version as a variable called `vault_version` in your `terraform.tfvars` file.
      - Syntax used is (as an example): `1.17.0`, `1.17.0+ent`
      - **terraform.tfvars**
        ```
        vault_version = "<YOUR DESIRED vault version>"
        ```
  - ### Step 2
    - Run `terraform apply`
    - Type `yes` and hit enter.
      - **Note**: Instances with the updated Vault version will only be created on *new* instances. It will not upgrade existing instances.

## Load Balancers
  - ### Step 1
    - Add a variable called `create_load_balancer` in your `terraform.tfvars` file and set it to `true`.
      - **terraform.tfvars**
        ```
        create_load_balancer = true
        ```
  - ### Step 2
    - Run `terraform apply`
    - Type `yes` and hit enter.
    - **Note**: You can change this to a network load balancer by setting the variable `load_balancer_type` to `network` (it is `application` by default).

## Replication
  - ### Step 1
    - Add a variable called `create_secondary_cluster` in your `terraform.tfvars` file and set it to `true`.
      - **terraform.tfvars**
        ```
        create_secondary_cluster = true
        ```
  - ### Step 2
    - Run `terraform apply`
    - Type `yes` and hit enter.
