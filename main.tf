terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"

  vpc_names            = var.vpc_names
  base_cidr            = var.base_cidr
  availability_zones   = var.availability_zones
  public_subnet_count  = var.public_subnet_count
  private_subnet_count = var.private_subnet_count
  tags                 = var.tags
}