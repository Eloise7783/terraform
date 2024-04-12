resource "aws_instance" "module" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = var.subnet_id

  tags = var.tags
}
#everything we want to set has to be templated in the module.

variable "ami" {
    default = "ami-0fb391cce7a602d1f"
}
variable "instance_type" {
    default = "t2.micro"
}
variable "subnet_id" {}
variable "tags" {
    type = map(string)
    default = {}
}
