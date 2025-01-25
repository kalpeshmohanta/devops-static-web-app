# Generates a random string of 8 characters (without special characters) to make the cluster name unique
resource "random_string" "suffix" {
  length  = 8
  special = false
}


module "eks"  {
    source = "terraform-aws-modules/eks/aws"
    version = "20.31.6"

    cluster_name = "${var.cluster-name}-${random_string.suffix.result}"
    vpc_id                   = module.vpc.vpc_id
    subnet_ids               = module.vpc.private_subnets # Private subnets for worker nodes + EKS control plane


    # Disable public access to the cluster endpoint
    cluster_endpoint_public_access = false
    # Enable private access for cluster endpoint
    cluster_endpoint_private_access = true


    # Enable cluster creator admin permissions (IAM ROOT User)
    enable_cluster_creator_admin_permissions = true



    # EKS manged node groups
    eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    instance_types         = ["t2.large"]
    # Security Group attached to worker nodes, it allows worker nodes to communicate with the EKS control plane
    vpc_security_group_ids = [aws_security_group.worker_sg.id]
    }

    eks_managed_node_groups = {
    node_group = {
        min_size     = 1
        max_size     = 2
        desired_size = 1

        # Change with general purpose instance types for production
        instance_types = ["t2.large"]
        capacity_type  = "SPOT"   # Cost effective for testing
    }
    }
}

# Security Group for EKS Worker Nodes
resource "aws_security_group" "worker_sg" {
  vpc_id = module.vpc.vpc_id

  # Allow incoming traffic from the Bastion host's security group on port 443
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }
  
  # Allow outgoing traffic to access the internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "worker-sg"
  }
}


# Add an inbound rule to the already exist EKS control plane's security group(AWS managed Control Plane) to allow traffic from the Bastion Host
resource "aws_security_group_rule" "eks_control_plane_ingress" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = module.eks.cluster_security_group_id
  source_security_group_id = aws_security_group.ec2_sg.id
  description              = "Allow traffic from Bastion host to EKS control plane"
}