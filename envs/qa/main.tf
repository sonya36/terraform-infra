terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source              = "../../modules/vpc"
  name                = "vpc-${var.env}"
  cidr_block          = var.vpc_cidr
  azs                 = var.azs
  public_subnet_cidrs = var.public_subnets
  tags                = var.tags
}

module "s3" {
  source      = "../../modules/s3"
  bucket_name = var.app_bucket_name
  tags        = var.tags
}

module "ec2" {
  source        = "../../modules/ec2"
  name          = "web-${var.env}"
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnet_ids[0]
  ami_id        = var.ami_id
  instance_type = var.instance_type
  tags          = var.tags
}