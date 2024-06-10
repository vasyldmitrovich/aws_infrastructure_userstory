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

  vpc_id = module.network.user_story_vpc_id
  gw_id = module.network.user_story_gw_id
  public_subnets = module.network.vpc_public_subnets_ids
  private_subnets = module.network.vpc_private_subnets_ids
}

module "front" {
  source = "./front/"
  sg_for_ec2_id = module.security.user_story_sg_for_ec2_id
  public_subnets_ids = module.network.vpc_public_subnets_ids
  private_subnets_ids = module.network.vpc_private_subnets_ids

  bucket_for_ec2 = module.s3.user_story_s3_id
  alb_tgt_grp_arn = module.lb.user_story_alb_tgt_grp_arn
  backend_count = module.lb.backend_count

}