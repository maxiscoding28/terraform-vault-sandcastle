#!/bin/bash

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

# Create raft storage and grant ownership
mkdir -p /opt/consul/data/
chown -R consul:consul /opt/consul/
chown -R consul:consul /opt/consul/data

# Create config for vault directory
mkdir /etc/consul.d/
chown -R consul:consul /etc/consul.d/

# Install Consul
curl --silent -Lo /tmp/consul.zip https://releases.hashicorp.com/consul/${consul_version}/consul_${consul_version}_linux_amd64.zip
unzip /tmp/consul.zip
mv consul /usr/bin
rm -f /tmp/consul.zip

# Create consul server config file
cat > /etc/consul.d/server.hcl << EOF
log_level  = "info"
server     = true
datacenter = "consul-${server_name}"
data_dir           = "/opt/consul/data"
client_addr    = "0.0.0.0"
bootstrap_expect = ${desired_capacity}  
ui_config { enabled = true }
retry_join = ["provider=aws tag_key=join tag_value=consul-${server_name}"]
EOF

# Create Systemd
cat > /etc/systemd/system/consul.service << EOF
[Unit]
Description="HashiCorp Consul - A service mesh solution"
Documentation=https://www.consul.io/
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/consul.d/server.hcl

[Service]
Type=notify
User=consul
Group=consul
ExecStart=/usr/bin/consul agent -config-file=/etc/consul.d/server.hcl
ExecReload=/usr/bin/consul reload
KillMode=process
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

systemctl start consul