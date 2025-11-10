# data "aws_ami" "amazon_linux" {
#   most_recent = true
#   owners = ["amazon"]
#   filter { name = "name" values = ["amzn2-ami-hvm-*-x86_64-gp2"] }
# }

# resource "aws_instance" "temp_frontend" {
#   ami = data.aws_ami.amazon_linux.id
#   instance_type = var.frontend_instance_type
#   subnet_id = aws_subnet.public[0].id
#   key_name = var.public_key_name
#   vpc_security_group_ids = [aws_security_group.frontend_sg.id, aws_security_group.bastion_sg.id]
#   associate_public_ip_address = true

#   user_data = file("${path.module}/user_data_frontend.sh")

#   tags = { Name = "${var.project_name}-temp-frontend" }
# }

# resource "aws_instance" "temp_backend" {
#   ami = data.aws_ami.amazon_linux.id
#   instance_type = var.backend_instance_type
#   subnet_id = aws_subnet.public[1].id
#   key_name = var.public_key_name
#   vpc_security_group_ids = [aws_security_group.backend_sg.id, aws_security_group.bastion_sg.id]
#   associate_public_ip_address = true

#   user_data = file("${path.module}/user_data_backend.sh")

#   tags = { Name = "${var.project_name}-temp-backend" }
# }
