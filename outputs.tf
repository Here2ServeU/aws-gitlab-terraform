output "instance_id" {
  description = "The ID of the GitLab EC2 instance"
  value       = aws_instance.gitlab.id
}

output "public_ip" {
  description = "The public IP address of the GitLab EC2 instance"
  value       = aws_instance.gitlab.public_ip
}

output "gitlab_url" {
  description = "URL to access GitLab"
  value       = "http://${aws_instance.gitlab.public_ip}"
}