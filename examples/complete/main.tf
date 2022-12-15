provider "aws" {
  region = local.region
}

locals {
  region = "us-east-1"
  tags = {
    Name      = "Opensearch"
    terraform = true
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "opensearch"
  cidr = "10.35.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.35.11.0/24", "10.35.21.0/24", "10.35.31.0/24"]
  public_subnets  = ["10.35.12.0/24", "10.35.22.0/24", "10.35.32.0/24"]
  intra_subnets   = ["10.35.13.0/24", "10.35.23.0/24", "10.35.33.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true

  tags = local.tags
}


module "opensearch" {
  source = "../../"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  zone_awareness_enabled         = true
  engine_version                 = "OpenSearch_2.3"
  instance_type                  = "t3.small.search"
  instance_count                 = 2
  encrypt_at_rest_enabled        = false
  dedicated_master_enabled       = false
  create_iam_service_linked_role = false
  ebs_volume_size                = 20

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  tags = local.tags
}