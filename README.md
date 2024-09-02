## Deploying GitLab on EC2

* main.tf: Contains the primary configuration for the EC2 instance.
* variables.tf: Defines the variables used in the configuration.
* terraform.tfvars: Specifies the values for the variables.
* output.tf: Outputs useful information like the public IP address of the instance.

### Step One: Initialize Terraform: Initialize the working directory containing the configuration files.
terraform init

### Step Two: Review the Plan: See the execution plan for the Terraform configuration.
* terraform plan

### Step Three: Apply the Configuration: Apply the configuration to create the EC2 instance and install GitLab.
* terraform apply

### Step Three: Manually Install GitLab
**SSH into your EC2 Instance and use the following steps**
* sudo apt-get update
* sudo apt-get install -y curl openssh-server ca-certificates tzdata perl

**Install Postfix (or Sendmail) to send notification emails**
* sudo apt-get install -y postfix

**Add the GitLab package repository and install the package**
* curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash

**Install GitLab**
* sudo apt-get install gitlab-ee

**You get this**
Notes:
Default admin account has been configured with following details:
Username: root
Password: You didn't opt-in to print initial root password to STDOUT.
Password stored to /etc/gitlab/initial_root_password. 
This file will be cleaned up in first reconfigure run after 24 hours.

* cd /etc/gitlab
* sudo cat initial_root_password

### Step Four: Configure Email
* echo "gitlab_rails['gitlab_email_from'] = 't2scloud@gmail.com'" | sudo tee -a /etc/gitlab/gitlab.rb 
    # search for "contact" and use the required value for 'letsencrypt['contact_emails']'

### Step Five: Configure IP Address or Domain
* sudo sed -i "s|^external_url .*|external_url 'http://192.168.1.10'|" /etc/gitlab/gitlab.rb

### Step Six: Reconfigure GitLab
* sudo gitlab-ctl reconfigure

### Step Seven: Access GitLab
Once the instance is created, you can access GitLab using the URL provided in the output. The URL will be **http://<public_ip>** where ***<public_ip>*** is the public IP address of your EC2 instance.
