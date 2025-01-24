output "region" {
  description = "AWS region"
  value       = var.region
}

output "jenkins_eip" {
  description = "The Elastic IP address of the Jenkins server"
  value       = aws_eip.jenkins_eip.public_ip  
  }