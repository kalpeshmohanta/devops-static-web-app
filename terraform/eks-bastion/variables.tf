variable "region" {
  description = "AWS region to deploy resources"
  default = "ap-south-1"    # Mumbai region
}

variable "vpc-name"  {
    description = "vpc name"
    default = "kalpesh-vpc"
}

variable "vpc-cidr" {
    description = "vpc cidr block"
    default = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "cluster-name" {
    description = "eks cluster name"
    default = "kalpesh-eks"
}

variable "key_pair" {
    description = "key pair name"
    default = "aws_key_pair"
}
