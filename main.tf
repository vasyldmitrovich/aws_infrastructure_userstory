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

module "network" {
  source = "./networks/"
}

module "security" {
  source = "./security/"
  vpc_id = module.network.user_story_vpc_id
}

module "s3" {
  source = "./s3/"
}

module "lb" {
  source = "./lb/"
  sg_for_elb_id = module.security.user_story_sg_for_elb_id
  pub_sub1_id = module.network.user_story_pub_sub1_id
  pub_sub1a_id = module.network.user_story_pub_sub1a_id
  gw_id = module.network.user_story_gateway_id
  vpc_id = module.network.user_story_vpc_id
}

module "front" {
  source = "./front/"
  pub_sub1_id = module.network.user_story_pub_sub1_id
  sg_for_ec2_id = module.security.user_story_sg_for_ec2_id
  bucket_for_ec2 = module.s3.user_story_s3_id
  alb_tg_arn = module.lb.user_story_alb_tg_arn
  priv_sub1a_id = module.network.user_story_private_sub1a_id
}