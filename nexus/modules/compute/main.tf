variable "security_group" {
  description = "The security groups assigned to the Jenkins server"
}

variable "public_subnet" {
  description = "The public subnet IDs assigned to the Jenkins server"
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "nexus_server" {
  ami                    = data.aws_ami.amazon-linux-2.id
  subnet_id              = var.public_subnet
  instance_type          = "t2.medium"
  vpc_security_group_ids = [var.security_group]
  key_name               = "Ugonna-us"  # Specify an existing key-pair name
  #key_name              = aws_key_pair.tutorial_kp.key_name
  associate_public_ip_address =true
  user_data              = <<-EOF
    #!/bin/bash

    # Set execute permission for the Jenkins installation script
    chmod +x ${path.module}/install_nexus.sh

    # Install Jenkins
    ${file("${path.module}/install_nexus.sh")}
  EOF
  tags = {
    Name = "nexus_server"
  }
}

# Commented out the aws_key_pair resource
/*
resource "aws_key_pair" "tutorial_kp" {
  key_name   = "tutorial_kp"
  public_key = file("${path.module}/tutorial_kp.pub")
}

resource "aws_eip" "jenkins_eip" {
  instance = aws_instance.jenkins_server.id
  vpc      = true

  tags = {
    Name = "jenkins_eip"
  }
}
*/ 

