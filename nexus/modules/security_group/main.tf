variable "vpc_id" {
   description = "ID of the VPC"
   type        = string
}

#variable "my_ip" {
   #description = "My IP address"
   #type = string
#}

# Security Group
variable "ingressrules" {
  type    = list(number)
  default = [8081, 22]
}

resource "aws_security_group" "nexus_sg" {
  name_prefix = "nexus_sg"
  description = "Security group for Jenkins server"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules

    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nexus_sg"
  }
}
