terraform {
  required_version = ">= 1.10.0"

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
    tags = local.common_tags
  }
}

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = var.owner
  }
}

module "network" {
  source                   = "../../modules/network"
  name_prefix              = var.name_prefix
  vpc_cidr                 = var.vpc_cidr
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  azs                      = var.azs
  enable_nat_gateway       = var.enable_nat_gateway
  tags                     = local.common_tags
}

module "security" {
  source                 = "../../modules/security"
  name_prefix            = var.name_prefix
  vpc_id                 = module.network.vpc_id
  vpc_cidr               = var.vpc_cidr
  private_app_subnet_ids = module.network.private_app_subnet_ids
  app_port               = var.app_port
  tags                   = local.common_tags
}

module "iam" {
  source      = "../../modules/iam"
  name_prefix = var.name_prefix
  tags        = local.common_tags
}

module "compute" {
  source                     = "../../modules/compute"
  name_prefix                = var.name_prefix
  vpc_id                     = module.network.vpc_id
  public_subnet_ids          = module.network.public_subnet_ids
  private_app_subnet_ids     = module.network.private_app_subnet_ids
  alb_security_group_id      = module.security.alb_security_group_id
  app_security_group_id      = module.security.app_security_group_id
  instance_profile_name      = module.iam.ec2_instance_profile_name
  instance_type              = var.instance_type
  app_port                   = var.app_port
  root_volume_size           = var.root_volume_size
  data_volume_size           = var.data_volume_size
  desired_capacity           = var.desired_capacity
  min_size                   = var.min_size
  max_size                   = var.max_size
  cpu_target_value           = var.cpu_target_value
  enable_deletion_protection = var.enable_deletion_protection
  tags                       = local.common_tags
}

module "monitoring" {
  source                  = "../../modules/monitoring"
  name_prefix             = var.name_prefix
  asg_name                = module.compute.asg_name
  alb_arn_suffix          = module.compute.alb_arn_suffix
  target_group_arn_suffix = module.compute.target_group_arn_suffix
  sns_email               = var.sns_email
  cpu_alarm_threshold     = var.cpu_alarm_threshold
  log_retention_days      = var.log_retention_days
  tags                    = local.common_tags
}

module "backup" {
  source            = "../../modules/backup"
  name_prefix       = var.name_prefix
  backup_schedule   = var.backup_schedule
  delete_after_days = var.backup_delete_after_days
  tags              = local.common_tags
}
