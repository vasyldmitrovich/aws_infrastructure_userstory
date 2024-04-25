terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region     = var.instance_region
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}

resource "aws_key_pair" "deployer" {
  key_name   = var.key-name
  public_key = file("${path.module}/ec2_pub_key")
}

resource "aws_instance" "test_server" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name = aws_key_pair.deployer.key_name
  tags = {
    Name = "Test Linux 01"
    Env = "Dev"
  }

  iam_instance_profile = var.instance_role

  user_data = file("init_script_on_instance.sh")

  depends_on = [aws_s3_bucket.bucket_for_ec2]
}



