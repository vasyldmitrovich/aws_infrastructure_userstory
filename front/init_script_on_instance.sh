#!/bin/bash

# Install AWS CLI
sudo apt-get update
sudo apt-get install -y awscli

# Download files from S3
aws s3 cp s3://aws-s3-bucket-for-ec2-vbazh/ /home/ubuntu --recursive

# Install Apache
sudo apt update &&
sudo apt install apache2 -y &&
sudo ufw allow 'Apache' &&
sudo sed -i "/<body>/a\<h1>Hello World from $(hostname -f)</h1>" /var/www/html/index.html

sudo ls /home/ubuntu >> /var/www/html/index.html

# Run my script
chmod +x /home/ubuntu/db_and_app.sh
#/home/ubuntu/db_and_app.sh "/home/ubuntu"