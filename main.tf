provider "aws" {
  region = var.region
}

resource "aws_instance" "gitlab" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get upgrade -y
              sudo apt-get install -y curl openssh-server ca-certificates tzdata perl
              curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
              EOF

  tags = {
    Name = "GitLab-Instance"
  }

  vpc_security_group_ids      = [aws_security_group.gitlab_sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.gitlab_instance_profile.name

#   provisioner "local-exec" {
#     command = <<EOT
#       sleep 60  # Wait for instance to be fully up
#       external_ip=$(aws ec2 describe-instances --instance-ids ${self.id} --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
#       ssh -o StrictHostKeyChecking=no -i ${var.key_path} ubuntu@${external_ip} <<EOF
#       sudo EXTERNAL_URL=http://${external_ip} apt-get install gitlab-ee -y
#       EOF
#     EOT
#   }
}

resource "aws_security_group" "gitlab_sg" {
  name        = "gitlab_sg"
  description = "Allow SSH and HTTP access to GitLab instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "gitlab_role" {
  name = "gitlab_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "gitlab_policy" {
  name   = "gitlab_policy"
  role   = aws_iam_role.gitlab_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["ec2:Describe*"]
      Effect   = "Allow"
      Resource = "*"
    }]
  })
}

resource "aws_iam_instance_profile" "gitlab_instance_profile" {
  name = "gitlab_instance_profile"
  role = aws_iam_role.gitlab_role.name
}