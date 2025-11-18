#!/bin/bash
# --- Frontend User Data Script for Amazon Linux 2 ---

# Terraform variable (Backend ALB DNS)
BACKEND_ALB_DNS="${backend_alb_dns}"

# ------------------------------
# Step 1: Install Dependencies
# ------------------------------

yum update -y
yum install -y httpd git

# Install Node.js 18
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

echo "Dependencies installed."

# ------------------------------
# Step 2: Start Apache
# ------------------------------

systemctl start httpd
systemctl enable httpd

# ------------------------------
# Step 3: Clone Frontend Code
# ------------------------------

# Work inside ec2-user home
cd /home/ec2-user


# Clone the repo
git clone https://github.com/CloudTechDevOps/2nd10WeeksofCloudOps-main.git

# Fix permissions
chown -R ec2-user:ec2-user /home/ec2-user/2nd10WeeksofCloudOps-main

echo "Repository cloned."

# ------------------------------
# Step 4: Update config.js and Build React App
# ------------------------------

sudo -u ec2-user -H bash -c "
cd /home/ec2-user/2nd10WeeksofCloudOps-main/client && \
echo 'Updating API endpoint to: http://$BACKEND_ALB_DNS' && \
sed -i \"s|http://.*|http://$BACKEND_ALB_DNS\" src/config.js
"

# Install Node modules
sudo -u ec2-user -H bash -c "
cd /home/ec2-user/2nd10WeeksofCloudOps-main/client && npm install
"

# Build React
sudo -u ec2-user -H bash -c "
cd /home/ec2-user/2nd10WeeksofCloudOps-main/client && npm run build
"

echo "Frontend build completed."

# ------------------------------
# Step 5: Deploy to Apache
# ------------------------------

rm -rf /var/www/html/*
cp -r /home/ec2-user/2nd10WeeksofCloudOps-main/client/build/* /var/www/html/
chown -R apache:apache /var/www/html

echo "Frontend deployed successfully."
