#!/bin/bash
# --- Backend User Data Script for Amazon Linux 2 ---

# Terraform variables
DB_HOST="${db_host}"
DB_USER="${db_user}"
DB_PASSWORD="${db_password}"

# ------------------------------
# Step 1: Install Dependencies
# ------------------------------

yum update -y
yum install -y git mysql

# Install Node.js 18
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

# Install PM2 globally
npm install -g pm2

echo "Dependencies installed."

# ------------------------------
# Step 2: Clone Application Code
# ------------------------------

# Switch to ec2-user home
cd /home/ec2-user

# Clone the repository
git clone https://github.com/CloudTechDevOps/2nd10WeeksofCloudOps-main.git

# Set correct permissions so ec2-user owns the files
chown -R ec2-user:ec2-user /home/ec2-user/2nd10WeeksofCloudOps-main

echo "Repository cloned."

# ------------------------------
# Step 3: Backend Setup
# ------------------------------

sudo -u ec2-user -H bash -c "cd /home/ec2-user/2nd10WeeksofCloudOps-main/backend && \
cat <<EOF > .env
DB_HOST=$DB_HOST
DB_USERNAME=$DB_USER
DB_PASSWORD=$DB_PASSWORD
PORT=3306
EOF"

echo ".env file created."

# Install Node packages as ec2-user
sudo -u ec2-user -H bash -c "cd /home/ec2-user/2nd10WeeksofCloudOps-main/backend && npm install && npm install dotenv"

# Wait for RDS to be ready
sleep 30

# Initialize DB
sudo -u ec2-user -H bash -c "cd /home/ec2-user/2nd10WeeksofCloudOps-main/backend && mysql -h $DB_HOST -u $DB_USER < test.sql"

echo "Database initialized."

# ------------------------------
# Step 4: Start Backend with PM2
# ------------------------------

sudo -u ec2-user -H bash -c "cd /home/ec2-user/2nd10WeeksofCloudOps-main/backend && pm2 start index.js --name backendApi"

sudo -u ec2-user -H bash -c "pm2 save"
sudo pm2 startup systemd -u ec2-user --hp /home/ec2-user

echo "Backend app started with PM2."

# ------------------------------
# Completed
# ------------------------------
echo "Backend setup completed successfully."
