#!/bin/bash

# Create vault user
useradd vault
groupadd vault
usermod -aG vault vault
usermod -aG wheel vault
echo 'vault ALL=(ALL:ALL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers
mkdir -p /home/vault
chown vault:vault /home/vault
mkdir -p /home/vault/.ssh
chown vault:vault /home/vault/.ssh
chmod 700 /home/vault/.ssh
cp -R /home/ec2-user/.ssh/authorized_keys /home/vault/.ssh/authorized_keys
chown vault:vault /home/vault/.ssh/authorized_keys
chmod 700 /home/vault/.ssh/authorized_keys

# Create consul user
useradd consul
groupadd consul
usermod -aG consul consul
usermod -aG wheel consul
echo 'consul ALL=(ALL:ALL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers
mkdir -p /home/consul
chown consul:consul /home/consul
mkdir -p /home/consul/.ssh
chown consul:consul /home/consul/.ssh
chmod 700 /home/consul/.ssh
cp -R /home/ec2-user/.ssh/authorized_keys /home/consul/.ssh/authorized_keys
chown consul:consul /home/consul/.ssh/authorized_keys
chmod 700 /home/consul/.ssh/authorized_keys

# Install Vault
curl --silent -Lo /tmp/vault.zip https://releases.hashicorp.com/vault/${vault_version}/vault_${vault_version}_linux_amd64.zip
unzip /tmp/vault.zip
mv vault /usr/bin
rm -f /tmp/vault.zip

# Install Consul
curl --silent -Lo /tmp/consul.zip https://releases.hashicorp.com/consul/${consul_version}/consul_${consul_version}_linux_amd64.zip
unzip /tmp/consul.zip
mv consul /usr/bin
rm -f /tmp/consul.zip

# Create consul directory
mkdir /opt/consul/
mkdir /opt/consul/data
chown consul:consul /opt/consul/data

# Create vault config
mkdir /etc/vault.d
chown vault:vault /opt/vault

# Create consul config
mkdir /etc/consul.d
chown consul:consul /etc/consul.d

# Create license file
echo ${vault_license} > /etc/vault.d/license.hclic

cat > /etc/vault.d/server.hcl << EOF
listener "tcp" {
    address = "0.0.0.0:8200"
    cluster_address = "0.0.0.0:8201"
    tls_disable = 1
}
storage "consul" {
  address = "127.0.0.1:8500"
  path    = "vault/"
}
seal "awskms" {
  kms_key_id = "${kms_key_arn}"
}

api_addr = "http://{{ GetPrivateInterfaces | attr \"address\" }}:8200"
cluster_addr = "http://{{ GetPrivateInterfaces | attr \"address\" }}:8201"

log_level = "debug"
raw_storage_endpoint = true
ui = true
license_path = "/etc/vault.d/license.hclic"
EOF

cat > /etc/consul.d/agent.hcl << EOF
  server     = false
  datacenter = "consul-primary"
  data_dir   = "/opt/consul/data"
  log_level  = "debug"
  retry_join = ["provider=aws tag_key=Name tag_value=consul-sandcastle"]
  client_addr    = "0.0.0.0"
EOF

# Create Systemd file
cat > /etc/systemd/system/vault.service << EOF
[Unit]
Description="HashiCorp Vault - A tool for managing secrets"
Documentation=https://developer.hashicorp.com/vault/docs
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/vault.d/server.hcl
StartLimitIntervalSec=60
StartLimitBurst=3

[Service]
Type=notify
User=vault
Group=vault
ProtectSystem=full
ProtectHome=read-only
PrivateTmp=yes
PrivateDevices=yes
SecureBits=keep-caps
AmbientCapabilities=CAP_IPC_LOCK
CapabilityBoundingSet=CAP_SYSLOG CAP_IPC_LOCK
NoNewPrivileges=yes
ExecStart=/usr/bin/vault server -config=/etc/vault.d/server.hcl
ExecReload=/bin/kill --signal HUP $MAINPID
KillMode=process
KillSignal=SIGINT
Restart=on-failure
RestartSec=5
TimeoutStopSec=30
LimitNOFILE=65536
LimitMEMLOCK=infinity
LimitCORE=0

[Install]
WantedBy=multi-user.target
EOF

cat > /etc/systemd/system/consul.service << EOF
[Unit]
Description="HashiCorp Consul - A service mesh solution"
Documentation=https://www.consul.io/
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/consul.d/agent.hcl

[Service]
Type=notify
User=consul
Group=consul
ExecStart=/usr/bin/consul agent -config-file=/etc/consul.d/agent.hcl
ExecReload=/usr/bin/consul reload
KillMode=process
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

# Change Vault ADDR to non-TLS
cat > /etc/profile.d/vault-settings.sh << EOF
export VAULT_ADDR=http://127.0.0.1:8200
EOF

# Start Vault
# systemctl start vault
systemctl start consul
systemctl start vault