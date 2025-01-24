provider "aws" {
  region = var.region
}

# Jenkins EC2 Spot Instance
resource "aws_instance" "jenkins_spot_instance" {
  ami           = "ami-053b12d3152c0cc71"  # Ubuntu - ap-south-1
  instance_type = "t2.large"
  subnet_id     = module.vpc.public_subnets[0]
  key_name      = var.key_pair  # Replace with your key pair name
  associate_public_ip_address = true  # Add this line to enable public IP

   root_block_device {
    volume_size           = 30
    volume_type          = "gp3"
    delete_on_termination = true
  }

  # Spot Instance
  instance_market_options {
    market_type = "spot"
    spot_options {
      spot_instance_type = "persistent" # Use to avoid changing spot instance type 
      instance_interruption_behavior = "stop" # Use to avoid termination of spot instance
    }
  }

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "jenkins-Spot-Instance"
  }
}

# Elastic IP
resource "aws_eip" "jenkins_eip" {
    instance = aws_instance.jenkins_spot_instance.id
    domain   = "vpc"

    tags = {
      Name = "jenkins-eip"
    }

    depends_on = [aws_instance.jenkins_spot_instance]
  }

# Security Group for Bastion Host
resource "aws_security_group" "ec2_sg" {
  name        = "jenkins-spot-security-group"
  description = "Security group for EC2 spot instance"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict to specific IPs in production
  }

  # Allow outgoing traffic to access the internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-Spot-Security-Group"
  }
}