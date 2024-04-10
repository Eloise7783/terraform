provider "aws" {
    profile = "default"
    region = "eu-west-2"
}

provider "aws" {
    alias = "US"
    region = "us-west-1"
    # in resource block, provider = "aws.US"
}

resource "aws_instance" "demo1" {
    ami = "ami-09a2a0f7d2db8baca"
    instance_type = "t2.micro"
    user_data_replace_on_change = true
        user_data =<<-EOF
        #!/bin/bash
        sudo apt-get update -y
        sudo apt install mysql-client -y
        EOF
    tags = {
        Name = "Made by Terraform!"
    }
}
# terraform fmt = adjusts syntax
# terraform validate = validates options (NOT values)
# terraform destroy -target=[resource_type.resource_name.resource_attribute] - not recommended

#commenting out or deleting the referential code will destroy the resources
locals {
  project_name = "Eloise"
}
resource "aws_instance" "demo2" {
    ami = "ami-0fb391cce7a602d1f"
    instance_type = "t2.nano"
    key_name = "mod5"
    tags = {
        Name = "Made by Terraform! -${local.project_name}"
    }
}
resource "aws_s3_bucket" "s3-bucket" {
    bucket = var.s3_bucket_name
  
}