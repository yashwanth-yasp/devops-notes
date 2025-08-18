terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Project   = var.project_name
      Owner     = var.owner
    }
  }
}

# Network Module
module "network" {
  source = "./modules/network"

  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  project_name         = var.project_name
  environment          = var.environment
}

# Compute Module
module "compute" {
  source = "./modules/compute"

  vpc_id             = module.network.vpc_id
  subnet_ids         = module.network.public_subnet_ids
  security_group_ids = [module.network.web_security_group_id]
  instance_type      = var.instance_type
  key_pair_name      = var.key_pair_name
  instance_count     = var.instance_count
  project_name       = var.project_name
  environment        = var.environment
  enable_monitoring  = var.enable_monitoring
  root_volume_size   = var.root_volume_size

  depends_on = [module.network]
}
