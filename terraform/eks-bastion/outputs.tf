output "cluster_id" {
  description = "EKS cluster ID."
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = module.eks.cluster_security_group_id
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider for EKS cluster IAM role association"
  value = module.eks.oidc_provider_arn
}

output "spot_instance_public_ip" {
  description = "Public IP of the EC2 spot instance"
  value       = aws_instance.spot_instance.public_ip
}