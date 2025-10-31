provider "aws" {
  
}

# create vpc
resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name =  "ace-vpc"
  }
  }

# create subnets
resource "aws_subnet" "name" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "ace-subnet-public"
  }
}

resource "aws_subnet" "name-2" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "ace-subnet-public-2"
  }
}

resource "aws_subnet" "pvt-1" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "ace-subnet-private-1"
  }
}

resource "aws_subnet" "pvt-2" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "ace-subnet-private-2"
  }
}

# create internet gateway
resource "aws_internet_gateway" "name" {
  vpc_id = aws_vpc.name.id
}
# create nat gateway
resource "aws_eip" "name" {
  domain = "vpc"
  tags = {
    Name = "nat-eip"
  }
}

resource "aws_nat_gateway" "name" {
  allocation_id = aws_eip.name.id
  subnet_id     = aws_subnet.name-2.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.name]
}
# create 2 route table
resource "aws_route_table" "name" {
    vpc_id = aws_vpc.name.id

   route {

    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.name.id

   }
}

resource "aws_route_table" "name-1" {
    vpc_id = aws_vpc.name.id

   route {

    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.name.id

   }
}
# create subnet associations
resource "aws_route_table_association" "name" {
  subnet_id      = aws_subnet.name.id
  route_table_id = aws_route_table.name.id
}

resource "aws_route_table_association" "namme-1" {
  subnet_id      = aws_subnet.name-2.id
  route_table_id = aws_route_table.name.id
}

resource "aws_route_table_association" "name-2" {
  subnet_id      = aws_subnet.pvt-1.id
  route_table_id = aws_route_table.name-1.id
}

resource "aws_route_table_association" "name-3" {
  subnet_id      = aws_subnet.pvt-2.id
  route_table_id = aws_route_table.name-1.id
}
# create security group
resource "aws_security_group" "sg" {
  name   = "allow_tls"
  vpc_id = aws_vpc.name.id
  tags = {
    Name = "dev-sg"
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# create servers
resource "aws_instance" "public" {
    ami = "ami-07860a2d7eb515d9a"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.name.id
    vpc_security_group_ids = [ aws_security_group.sg.id ]
    associate_public_ip_address = true
    tags = {
      Name = "public-ec2"
    }
  
}
resource "aws_instance" "pvt" {
    ami = "ami-07860a2d7eb515d9a"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.pvt-1.id
    vpc_security_group_ids = [ aws_security_group.sg.id ]
    
    tags = {
      Name = "pvt-ec2"
    }
}
