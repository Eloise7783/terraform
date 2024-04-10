provider "aws" {
    profile = "default"
    region = "eu-west-2"
}
# <Lab 4>
resource "aws_instance" "lab-4-ec2" {
  ami = "ami-0fb391cce7a602d1f"
  instance_type = "t2.micro"
  key_name = "lab4-key" 
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
     tags = {
         Name = "lab4-server"
         project = var.project_name
     }
     depends_on = [aws_key_pair.lab4-keypair]
    }
resource "aws_s3_bucket" "s3-bucket" {
    bucket = var.s3_bucket_name
  }
resource "aws_security_group" "allow_ssh" {
    name = var.security_group_name
    description = "allow ssh access"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        project = var.project_name
    }
}
resource "aws_key_pair" "lab4-keypair" {
   key_name = "lab4-key"
   public_key = tls_private_key.lab4-priv-key.public_key_openssh
}
resource "tls_private_key" "lab4-priv-key" {
  algorithm  = "RSA"
  rsa_bits = 4096
}  
resource "local_file" "TF_key" {
    content = tls_private_key.lab4-priv-key.private_key_pem
    filename = "tf_key"
}

output "lab4_vm_public_ip" {
        value = aws_instance.lab-4-ec2.public_ip
}

# </Lab 4>
# provider "aws" 
#     alias = "US"
#     region = "us-west-1"
#     # in resource block, provider = "aws.US"
# }

# resource "aws_instance" "demo1" {
#     ami = "ami-09a2a0f7d2db8baca"
#     instance_type = "t2.micro"
#     user_data_replace_on_change = true
#         user_data =<<-EOF
#         #!/bin/bash
#         sudo apt-get update -y
#         sudo apt install mysql-client -y
#         EOF
#     tags = {
#         Name = "Made by Terraform!"
#     }
# }
# terraform fmt = adjusts syntax
# terraform validate = validates options (NOT values)
# terraform destroy -target=[resource_type.resource_name.resource_attribute] - not recommended

#commenting out or deleting the referential code will destroy the resources
# locals {
#   project_name = "Eloise"
# }
# resource "aws_instance" "demo2" {
#     ami = "ami-0fb391cce7a602d1f"
#     instance_type = "t2.nano"
#     key_name = "mod5"
#     tags = {
#         Name = "Made by Terraform! -${local.project_name}"
#     }
#}

