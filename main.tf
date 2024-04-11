provider "aws" {
    profile = "default"
    region = "eu-west-2"
}
resource "aws_vpc" "lab5-vpc" {
    cidr_block = "10.10.0.0/20"
    enable_dns_hostnames = true
}
resource "aws_subnet" "subnet1" {
  cidr_block = "10.10.0.0/24"
  availability_zone = "eu-west-2a" 
  vpc_id = aws_vpc.lab5-vpc.id
  map_public_ip_on_launch = true 
}
resource "aws_subnet" "subnet2" {
  cidr_block = "10.10.1.0/24"
  availability_zone = "eu-west-2b" 
  vpc_id = aws_vpc.lab5-vpc.id
  map_public_ip_on_launch = true 
}
resource "aws_security_group" "sg1" {
    description = "vpc security group"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80 
        to_port = 80
        protocol = "tcp" 
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"  
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0 
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    vpc_id = aws_vpc.lab5-vpc.id 
}
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.lab5-vpc.id 
}
resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.lab5-vpc.id
}
resource "aws_route" "route" {
    route_table_id = aws_route_table.route-table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id

}
resource "aws_route_table_association" "route-table-association-1" {
    subnet_id = aws_subnet.subnet1.id
    route_table_id = aws_route_table.route-table.id
}
resource "aws_route_table_association" "route-table-association-2" {
    subnet_id = aws_subnet.subnet2.id
    route_table_id = aws_route_table.route-table.id
}
resource "aws_instance" "lab-5-ec2" {
  ami = "ami-0fb391cce7a602d1f"
  instance_type = "t2.micro"
  key_name = "lab4-key" 
  vpc_security_group_ids = [aws_security_group.sg1.id]
  subnet_id = aws_subnet.subnet1.id
     depends_on = [aws_key_pair.lab4-keypair]
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

output "lab5_vm_public_ip" {
        value = aws_instance.lab-5-ec2.public_ip
}
output "lab5_vpc_id" {
        value = aws_vpc.lab5-vpc.id
}
output "subnet_id_1" {
        value = aws_subnet.subnet1.id
}
output "subnet_id_2" {
        value = aws_subnet.subnet2.id
}
output "lab5_sec_group_id" {
        value = aws_security_group.sg1.id
}
# </Lab 4>
# provider "aws" 
#     alias = "US"
#     region = "us-west-1"
#     # in resource block, provider = "aws.US"
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

