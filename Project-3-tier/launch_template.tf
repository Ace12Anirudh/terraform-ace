data "aws_ami" "frontend" {
    most_recent = true
    owners = ["self"]

    filter {
      name = "name"
      values = ["frontend-ami"]
    }
}

# data "template_file" "frontend_user_data" {
#   template = file("${path.module}/user_data_frontend.sh")
#   vars = {
#     # This references the DNS name of the backend load balancer you created
#     __YOUR_BACKEND_ALB_DNS_NAME__ = aws_lb.back_end.dns_name
#   }
# }

# Launch Template Resource
resource "aws_launch_template" "frontend" {
    name = "frontend-terraform"
    description = "frontend-terraform"
    image_id = data.aws_ami.frontend.id
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.frontend-sg.id]
    key_name = "ace-key"
    update_default_version = true
    user_data = base64encode(templatefile("${path.module}/user_data_frontend.sh", {
      # The key on the left MUST EXACTLY MATCH the placeholder in the .sh file
      backend_alb_dns = aws_lb.back_end.dns_name 
       }))
    
    tag_specifications {
      resource_type = "instance"
      tags = {
        Name = "frontend-terraform"
      }
    }
}

#############################################

data "aws_ami" "backend"{
    most_recent = true
    owners = ["self"]

    filter {
      name = "name"
      values = ["backend-ami"]
    }
}

# data "template_file" "backend_user_data" {
#   template = file("${path.module}/user_data_backend.sh")
#   vars = {
#     # These reference the RDS instance details from your Terraform resources
#     __YOUR_RDS_ENDPOINT__  = aws_db_instance.rds.endpoint
#     __YOUR_RDS_USERNAME__  = aws_db_instance.rds.username
#     # For the password, it's best to use a secret manager or a variable
#     __YOUR_RDS_PASSWORD__  = var.db_password 
#   }
# }

# Launch template
resource "aws_launch_template" "backend" {
    name = "backend-terraform"
    description = "backend-terraform"
    image_id = data.aws_ami.backend.id
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.backend-sg.id]
    key_name = "ace-key"
    update_default_version = true
    user_data = base64encode(templatefile("${path.module}/user_data_backend.sh", {
    # The keys here MUST EXACTLY MATCH the placeholders in the .sh file
      db_host     = aws_db_instance.rds.address # Use .address for endpoint
      db_user     = aws_db_instance.rds.username
      db_password = var.db_password
    }))
    tag_specifications {
      resource_type = "instance"
      tags = {
        Name = "backend-terraform"
      }
    }
  
}