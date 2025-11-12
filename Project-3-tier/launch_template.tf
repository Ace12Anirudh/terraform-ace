data "aws_ami" "frontend" {
    most_recent = true
    owners = ["self"]

    filter {
      name = "name"
      values = ["frontend-ami"]
    }
}

# Launch Template Resource
resource "aws_launch_template" "frontend" {
    name = "frontend-terraform"
    description = "frontend-terraform"
    image_id = data.aws_ami.frontend.id
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.frontend-sg.id]
    key_name = "ace-key"
    update_default_version = true
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

# Launch template
resource "aws_launch_template" "backend" {
    name = "backend-terraform"
    description = "backend-terraform"
    image_id = data.aws_ami.backend.id
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.backend-sg.id]
    key_name = "ace-key"
    update_default_version = true
    tag_specifications {
      resource_type = "instance"
      tags = {
        Name = "backend-terraform"
      }
    }
  
}