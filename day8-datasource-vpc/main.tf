resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "dev"
    }
  
}
resource "aws_subnet" "subnet-1" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    tags = {
      Name = "subnet-1"
    }
}
resource "aws_subnet" "subnet-2" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1b"
    tags = {
      Name = "subnet-2"
    }
  
}

#####data-source########
# What is Data Source?
# Data source in terraform relates to resources but only it gives the information about an object rather than creating one. It provides dynamic information about the entities we define outside of terraform.
# Data Sources allow fetching data about the infrastructure components’ configuration. It allows to fetch data from the cloud provider APIs using terraform scripts.
# When we refer to a resource using a data source, it won’t create the resource. Instead, they get information about that resource so that we can use it in further configuration if required.



