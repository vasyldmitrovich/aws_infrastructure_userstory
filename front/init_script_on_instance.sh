#!/bin/bash

# Install AWS CLI
sudo apt-get update
sudo apt-get install -y awscli

# Download files from S3
aws s3 cp s3://aws-s3-bucket-for-ec2-vbazh/ /home/ubuntu --recursive

# Run my script
chmod +x /home/ubuntu/db_and_app.sh
/home/ubuntu/db_and_app.sh "/home/ubuntu"