variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
  default     = "t2.medium"
}

variable "key_name" {
  description = "The name of the SSH key pair"
  type        = string
}

variable "key_path" {
  description = "Path to the SSH private key file"
  type        = string
}