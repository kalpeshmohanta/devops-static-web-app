module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.17.0"

  name = var.vpc-name
  cidr = var.vpc-cidr

  azs = var.availability_zones
  public_subnets  = var.public_subnet_cidrs

}