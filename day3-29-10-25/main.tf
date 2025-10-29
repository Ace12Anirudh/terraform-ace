resource "aws_instance" "name" { 
    instance_type = var.type
     ami = var.ami_id
     tags = {
       Name = "prod"
     }


  
}



resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
  
}