#!/bin/bash
# --- User Data for Backend Server on Amazon Linux 2 ---
# This script configures the backend instance for the 3-tier application.

# --- !! IMPORTANT !! ---
# These placeholders will be replaced by Terraform with your actual RDS database details.
# NEW, CORRECT WAY
export DB_HOST="${db_host}"
export DB_USER="${db_user}"
export DB_PASSWORD="${db_password}"
# ------------------------

# --- Step 1: Install All Dependencies ---
# Update all installed packages
yum update -y

# Install Git, MySQL client (to connect to RDS), and build tools.
# 'mysql' package provides the client tools needed to connect to RDS.
yum install -y git mysql

# Install Node.js v18.x
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

# Install PM2, a production process manager for Node.js applications, globally.
npm install -g pm2

echo "All backend dependencies installed successfully."

# --- Step 2: Clone and Configure Application ---
# Work in the ec2-user's home directory
cd /root

# Clone the application repository
git clone https://github.com/CloudTechDevOps/2nd10WeeksofCloudOps-main.git

# Navigate to the backend directory
cd 2nd10WeeksofCloudOps-main/backend

# Create the .env file non-interactively with the database credentials from Terraform
echo "Creating .env file with database credentials..."
cat <<EOF > .env
DB_HOST=${db_host}
DB_USERNAME=${db_user}
DB_PASSWORD=${db_password}
PORT=3306
EOF

# --- Step 3: Install Packages and Initialize Database ---
# Install project-specific Node.js packages
npm install
npm install dotenv

# Wait for 30 seconds to give the RDS database time to become fully available
echo "Waiting 30 seconds for RDS to be ready..."
sleep 30

# Set the MySQL password as an environment variable to avoid interactive prompts
export MYSQL_PASSWORD=${db_password}

# Initialize the database schema by running the test.sql script against the RDS instance
echo "Initializing database schema on ${db_host}..."
mysql -h "${db_host}" -u "${db_user}" < test.sql

# --- Step 4: Start Application with PM2 ---
# Start the Node.js application using PM2, giving it a friendly name
pm2 start index.js --name "backendApi"

# Configure PM2 to automatically restart on system reboot for the 'ec2-user'.
# The user and home path are critical for this command to work correctly.
# pm2 startup systemd -u ec2-user --hp /home/ec2-user

# Save the current list of running processes so PM2 can resurrect them on reboot
pm2 save

echo "Backend setup completed successfully. API is running via PM2."