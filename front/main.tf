resource "aws_key_pair" "deployer" {
  key_name   = var.key-name
  public_key = file("${path.module}/ec2_pub_key")
}

# ASG with Launch template
resource "aws_launch_template" "test_server" {
  name_prefix   = "user_story_test_server"
  image_id           = var.instance_ami
  instance_type = var.instance_type
  key_name = aws_key_pair.deployer.key_name

  network_interfaces {
    associate_public_ip_address = false
    subnet_id                   = var.priv_sub1a_id
    security_groups             = [var.sg_for_ec2_id]
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "UserStory-instance"
    }
  }

  iam_instance_profile {
    arn = var.instance_role
  }

  user_data = filebase64("init_script_on_instance.sh")

  depends_on = [null_resource.wait_for_bucket]
}

resource "aws_autoscaling_group" "user_story_asg" {
  # no of instances
  desired_capacity = 3
  max_size         = 4
  min_size         = 2

  # Connect to the target group
  target_group_arns = [var.alb_tg_arn]

  vpc_zone_identifier = [var.priv_sub1a_id]# Creating EC2 instances in private subnet

  launch_template {
    id      = aws_launch_template.test_server.id
    version = "$Latest"
  }
}

resource "null_resource" "wait_for_bucket" {
  triggers = {
    bucket_for_ec2 = var.bucket_for_ec2
  }
}