resource "aws_key_pair" "deployer" {
  key_name   = var.key-name
  public_key = file("${path.module}/ec2key.pub")
}

# ASG with Launch template
resource "aws_launch_template" "user_story_serv" {
#  count = var.backend_count
#  name = "userstory_serv${count.index + 1}"
  name = "userstory_serv"
#  description = "Application ${count.index + 1}- Launch Template"
  description = "Application Launch Template"
  image_id           = var.instance_ami
  instance_type = var.instance_type
  key_name = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [var.sg_for_ec2_id]

  tag_specifications {
    resource_type = "instance"
    tags = {
#      Name = "UserStory-instance${count.index + 1}"
      Name = "UserStory-instance"
    }
  }
  iam_instance_profile {
    arn = var.instance_role
  }

  user_data = filebase64("${path.module}/init_script_on_instance.sh")

#  provisioner "remote-exec" {
#    inline = ["echo 'Wait until SSH is ready'"]
#
#    connection {
#      type        = "ssh"
#      user        = "ubuntu"
#      private_key = file(local.private_key_path)
#      host        = aws_instance.nginx.public_ip
#    }
#  }
#  provisioner "local-exec" {
#    command = "ansible-playbook  -i ${aws_instance.nginx.public_ip}, --private-key ${local.private_key_path} nginx.yaml"
#  }

  depends_on = [null_resource.wait_for_bucket]
}

resource "aws_autoscaling_group" "user_story_asg" {
#  count            = var.backend_count
#  name_prefix      = "myasg-${count.index + 1}"
  name_prefix      = "user_story_asg"
  desired_capacity = 2
  max_size         = 4
  min_size         = 1

  # Connect to the target group
  target_group_arns = [var.alb_tgt_grp_arn]
  vpc_zone_identifier = var.private_subnets_ids

  launch_template {
#    id      = aws_launch_template.user_story_serv[count.index].id
    id      = aws_launch_template.user_story_serv.id
    version = "$Latest"
  }
}

resource "aws_ec2_instance_connect_endpoint" "ec2_connect_endpoint" {
  subnet_id = var.private_subnets_ids[0]
  security_group_ids = [var.sg_for_ec2_id]
  preserve_client_ip = false
}

resource "null_resource" "wait_for_bucket" {
  triggers = {
    bucket_for_ec2 = var.bucket_for_ec2
  }
}