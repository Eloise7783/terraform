# resource "aws_security_group" "rds-ec2" {
#     name = "db-vm"
#     description = "connection to vm"
# }
# resource "aws_security_group" "ec2-rds" {
#     name = "vm-db"
#     description = "connection to db"

#     ingress {
#         from_port = 22 
#         to_port = 22
#         protocol = "tcp" 
#         cidr_blocks = ["0.0.0.0/0"]
#     }
#     ingress {
#         from_port = 80 
#         to_port = 80
#         protocol = "tcp"  
#         cidr_blocks = ["0.0.0.0/0"]
#     }
#     egress {
#         from_port = 0 
#         to_port = 0
#         protocol = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#     }
# }
# resource "aws_security_group_rule" "ec2-to-rds" {
#     security_group_id = aws_security_group.ec2-rds.id
#     type = "egress"
#     from_port =  3306
#     to_port = 3306
#     protocol = "tcp" 
#     source_security_group_id = aws_security_group.rds-ec2.id
# }
# resource "aws_security_group_rule" "rds-to-ec2" {
#     type = "ingress"
#     security_group_id = aws_security_group.rds-ec2.id
#     from_port = 3306
#     to_port = 3306
#     protocol = "tcp" 
#     source_security_group_id = aws_security_group.ec2-rds.id
# }
# resource "aws_key_pair" "lab4-keypair" {
#    key_name = "lab4-key"
#    public_key = tls_private_key.lab4-priv-key.public_key_openssh
# }
# resource "tls_private_key" "lab4-priv-key" {
#   algorithm  = "RSA"
#   rsa_bits = 4096
# }  
# resource "local_file" "TF_key" {
#     content = tls_private_key.lab4-priv-key.private_key_pem
#     filename = "tf_key"
# }
# resource "aws_instance" "db_ec2" {
#     ami = "ami-0fb391cce7a602d1f"
#     instance_type = "t2.micro"
#     key_name = "lab4-key" 
#     user_data_replace_on_change = true
#       user_data  = <<-EOF
#         #!/bin/bash
#         sudo apt-get update -y 
#         sudo apt install mysql-client -y
#         EOF
#   vpc_security_group_ids = [aws_security_group.ec2-rds.id]
#   depends_on             = [aws_key_pair.lab4-keypair]

# }
# resource "aws_db_subnet_group" "DB-subnet-group" {
#     name = "db-subnet-group"
#     subnet_ids = ["subnet-044f829aa2089d0e8", "subnet-0b35e0abf26802a50", "subnet-068d842ffe6ea82cb", "subnet-0ec4e2b95810e319f", "subnet-0dbbabcd430b1961d", "subnet-0c532559ebc567734"]
# }
# resource "aws_db_instance" "terraformDb" {
#     engine = "mysql"
#     engine_version = "8.0.35"
#     instance_class          = "db.t3.micro"
#     username                = "admin"
#     password                = "password"
#     allocated_storage       = 20
#     storage_type            = "gp2"
#     publicly_accessible     = false
#     skip_final_snapshot     = true
#     backup_retention_period = 0
#     vpc_security_group_ids  = [aws_security_group.rds-ec2.id]
#     db_subnet_group_name    = aws_db_subnet_group.DB-subnet-group.name

# }
# output "ec2_public_ip_for_mysql" {
#   value = aws_instance.db_ec2.public_ip
# }

# output "rds_endpoint" {
#   value = aws_db_instance.terraformDb.endpoint
# }
