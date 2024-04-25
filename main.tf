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

# ASG with Launch template
resource "aws_launch_template" "test_server" {
  name_prefix   = "test_server"
  image_id           = var.instance_ami
  instance_type = var.instance_type
  key_name = aws_key_pair.deployer.key_name

  network_interfaces {
    associate_public_ip_address = false
    subnet_id                   = aws_subnet.sh_subnet_2.id
    security_groups             = [aws_security_group.sh_sg_for_ec2.id]
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Sharmi-instance"
    }
  }

#  iam_instance_profile = var.instance_role???????????????????????????????????????????????????????
  iam_instance_profile {
    arn = var.instance_role
  }

  user_data = filebase64("init_script_on_instance.sh")

  depends_on = [aws_s3_bucket.bucket_for_ec2]
}

resource "aws_autoscaling_group" "sh_asg" {
  # no of instances
  desired_capacity = 3
  max_size         = 4
  min_size         = 2

  # Connect to the target group
  target_group_arns = [aws_lb_target_group.sh_alb_tg.arn]

  vpc_zone_identifier = [ # Creating EC2 instances in private subnet
    aws_subnet.sh_subnet_2.id
  ]

  launch_template {
    id      = aws_launch_template.test_server.id
    version = "$Latest"
  }
}