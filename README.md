- Quick Start
  - **Prequisites:**
    - Ensure you have credentials for an admin-like AWS user in the terminal shell where you will be running Terraform apply.
    - Run `aws sts get-caller-identity` to verify your AWS identity.

  - **Step 1**
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
- SSH-ing
   add ec2-key-pair variable

- Scale-in and Out
  - server_count

- Versioning
  - change version
  - only applies to new node

- Load Balancers
  - NLB wait for health checks to complete

- Replication
