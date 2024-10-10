provider "aws" {
  region = "ap-south-1"
}

# Variables for EC2 instance
variable "BuildAMI" {
  description = "Build Server AMI"
  default     = "ami-0dee22c13ea7a9a67"
}

variable "BuildType" {
  description = "Build Server Type"
  default     = "t2.medium"
}

variable "BuildKey" {
  description = "Build Server Key"
  default     = "devops"
}

variable "SecurityGroupID" {
  description = "Security Group ID"
  default     = "sg-0a4b86efefd9999b7"
}

# EC2 Instance Configuration
resource "aws_instance" "example" {
  ami                    = var.BuildAMI
  instance_type          = var.BuildType
  key_name               = var.BuildKey
  vpc_security_group_ids = [var.SecurityGroupID]

  tags = {
    Name = "Sonarqube"
  }

  # Connection details for SSH
  connection {
    type        = "ssh"
    user        = "ubuntu"   # or "ec2-user" depending on your AMI
    private_key =  file("/etc/ansible/devops.pem")  # update with your private key path
    host        = self.public_ip
  }

  # Use remote-exec to install Docker and SonarQube
  provisioner "remote-exec" {
    inline = [
      "sleep 40",
      "sudo apt-get update -y",
      "sudo apt-get install -y ca-certificates curl",
      "sudo install -m 0755 -d /etc/apt/keyrings",
      "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc",
      "sudo chmod a+r /etc/apt/keyrings/docker.asc",

      # Add Docker repository
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",

      # Install Docker and plugins
      "sudo apt-get update -y",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y",

      # Run SonarQube Docker container
      "sudo docker run -d --name sonarqube -p 9000:9000 sonarqube"
  ]
}

}
