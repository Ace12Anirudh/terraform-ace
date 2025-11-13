#!/bin/bash
# --- User Data for Frontend Server on Amazon Linux 2 ---
# This script configures the frontend instance for the 3-tier application.

# --- !! IMPORTANT !! ---
# This placeholder will be replaced by Terraform with the actual DNS name of your Backend Load Balancer.
# NEW, CORRECT WAY
export BACKEND_ALB_DNS="http://${backend_alb_dns}"
# ------------------------

# --- Step 1: Install All Dependencies ---
# Update all installed packages
yum update -y

# Install Apache web server (httpd), Git, and other necessary tools
yum install -y httpd git

# Install Node.js v18.x
# The nodesource script adds the required repository for a specific Node.js version.
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

echo "All frontend dependencies installed successfully."

# --- Step 2: Configure and Start Apache ---
systemctl start httpd
systemctl enable httpd # Ensure Apache starts on reboot

# --- Step 3: Clone and Configure Application ---
# We will work in the ec2-user's home directory for clarity and permissions
cd /root

# Clone the application repository
git clone https://github.com/CloudTechDevOps/2nd10WeeksofCloudOps-main.git

# Navigate to the client (frontend) directory
cd 2nd10WeeksofCloudOps-main/client

# Dynamically update the config.js file with the backend load balancer's DNS name.
echo "Updating API endpoint to ${backend_alb_dns}"
sed -i "s|${backend_alb_dns}|g" src/config.js

# --- Step 4: Build and Deploy Frontend Application ---
# Install project-specific Node.js packages from package.json
npm install

# Build the React application for production.
npm run build

# Copy the built static files to the Apache web root directory.
cp -r build/* /var/www/html/

# Ensure Apache has the correct ownership of the web files.
# On Amazon Linux, the Apache user and group are both 'apache'.
chown -R apache:apache /var/www/html

echo "Frontend setup completed successfully. Application is deployed."