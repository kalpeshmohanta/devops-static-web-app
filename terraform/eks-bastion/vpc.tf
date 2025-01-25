module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.17.0"

  name = var.vpc-name
  cidr = var.vpc-cidr

  azs = var.availability_zones
  public_subnets  = var.public_subnet_cidrs
  private_subnets = var.private_subnet_cidrs

  enable_nat_gateway = true # Craeted NAT in public subnet for internet access
  
}