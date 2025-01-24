variable "region" {
  description = "AWS region to deploy resources"
  default = "ap-south-1"    # Mumbai region
}

variable "vpc-name"  {
    description = "vpc name"
    default = "pipeline-vpc"
}

variable "vpc-cidr" {
    description = "vpc cidr block"
    default = "11.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["11.0.1.0/24", "11.0.2.0/24"]
}

variable "key_pair" {
    description = "key pair name"
    default = "aws_key_pair"
}