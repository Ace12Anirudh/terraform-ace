#!/bin/bash
set -e
# Cloud-init script to install Node, build React frontend and serve with nginx
# Placeholders: replace FRONTEND_GIT_REPO and API_URL as needed before creating AMI

FRONTEND_REPO="{{frontend_git_repo}}"
API_URL="{{REACT_APP_API_URL}}"

# update and install essentials
yum update -y
# install git and nginx
amazon-linux-extras install -y nginx1
yum install -y git

# install Node.js 18.x
curl -sL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

# create app dir and clone
APP_DIR=/home/ec2-user/frontend
rm -rf $APP_DIR
git clone $FRONTEND_REPO $APP_DIR || exit 1
chown -R ec2-user:ec2-user $APP_DIR

# build the react app (set env var at build time)
export $REACT_APP_VAR_NAME="{frontend_build_env_var}"
# If API_URL placeholder provided, inject into env and build
cd $APP_DIR
# If repo uses .env.production, create it
echo "REACT_APP_API_URL=$API_URL" > .env.production || true
npm install --legacy-peer-deps
npm run build || true

# deploy build to nginx
rm -rf /usr/share/nginx/html/*
cp -r $APP_DIR/build/* /usr/share/nginx/html/
systemctl enable nginx
systemctl start nginx
