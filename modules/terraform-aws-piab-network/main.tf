
data "aws_availability_zones" "azs" {}

locals {
  private_subnets = [for az in data.aws_availability_zones.azs.names : cidrsubnet(var.vpc_cidr, 8, index(data.aws_availability_zones.azs.names, az) + 1)]
  public_subnets  = [for az in data.aws_availability_zones.azs.names : cidrsubnet(var.vpc_cidr, 8, index(data.aws_availability_zones.azs.names, az) + 101)]
}

#tfsec:ignore:aws-vpc-no-excessive-port-access tfsec:ignore:aws-vpc-no-public-ingress-acl
module "vpc" {

  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.azs.names
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  tags = var.tags
}
