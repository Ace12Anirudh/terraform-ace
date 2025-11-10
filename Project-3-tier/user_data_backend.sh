#!/bin/bash
set -e
# Cloud-init script to install Node, clone backend, and run as systemd service
BACKEND_REPO="{{backend_git_repo}}"
BACKEND_DIR=/home/ec2-user/backend
PORT={{backend_port}}

yum update -y
yum install -y git
curl -sL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs
# create app dir and clone
rm -rf $BACKEND_DIR
git clone $BACKEND_REPO $BACKEND_DIR || exit 1
chown -R ec2-user:ec2-user $BACKEND_DIR
cd $BACKEND_DIR
npm install --legacy-peer-deps || true

# create environment file for systemd service (placeholders to be edited before AMI bake)
cat > /etc/backend_env <<'EOF'
# Replace placeholders with real values or set via user prior to AMI creation
DB_HOST="{{rds_endpoint_placeholder}}"
DB_USER="{{db_user_placeholder}}"
DB_PASS="{{db_pass_placeholder}}"
DB_NAME="{{db_name_placeholder}}"
PORT={{backend_port}}
EOF

# create systemd service
cat > /etc/systemd/system/backend.service <<'EOF'
[Unit]
Description=Node.js Backend
After=network.target

[Service]
Type=simple
User=ec2-user
EnvironmentFile=/etc/backend_env
WorkingDirectory=/home/ec2-user/backend
ExecStart=/usr/bin/node /home/ec2-user/backend/index.js
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable backend.service
systemctl start backend.service
