output "public_ip" {
   description = "The public IP address of the nexus server"
   value = aws_instance.nexus_server.public_ip
} 


