# Bastion EC2 Spot Instance
resource "aws_instance" "spot_instance" {
  ami           = "ami-053b12d3152c0cc71"  # Ubuntu - ap-south-1
  instance_type = "t2.micro"
  subnet_id     = module.vpc.public_subnets[0]
  key_name      = var.key_pair  # Replace with your key pair name
  associate_public_ip_address = true  # Add this line to enable public IP

  instance_market_options {
    market_type = "spot"
  }

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "Bastion-Spot-Instance"
  }
}

# Security Group for Bastion Host
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-spot-security-group"
  description = "Security group for EC2 spot instance"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict to specific IPs in production
  }

  # Allow outgoing traffic to access the internet as well as EKS cluster
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2-Spot-SG"
  }
}