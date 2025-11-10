
resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "terraform-vpc"
    }
}

resource "aws_internet_gateway" "ig" {
    vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "public-rt" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.ig.id
    }
    tags = {
      Name = "public-rt"
    }
}

resource "aws_route_table_association" "public-1" {
    subnet_id = aws_subnet.public-1.id
    route_table_id = aws_route_table.public-rt.id  
}
resource "aws_route_table_association" "public-2" {
    subnet_id = aws_subnet.public-2.id
    route_table_id = aws_route_table.public-rt.id  
}

resource "aws_subnet" "public-1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = var.az-1
    tags = {
        Name = "Public-1"
    }
}
resource "aws_subnet" "public-2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = var.az-2
    tags = {
        Name = "Public-2"
    }
}
resource "aws_subnet" "private-1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.3.0/24"
    availability_zone = var.az-1
    tags = {
        Name = "Frontend-1"
    }
}
resource "aws_subnet" "private-2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.4.0/24"
    availability_zone = var.az-2
    tags = {
        Name = "Frontend-2"
    }
}
resource "aws_subnet" "private-3" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.5.0/24"
    availability_zone = var.az-1
    tags = {
        Name = "Backend-1"
    }
}
resource "aws_subnet" "private-4" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.6.0/24"
    availability_zone = var.az-2
    tags = {
        Name = "Backend-2"
    }
}
resource "aws_subnet" "private-5" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.7.0/24"
    availability_zone = var.az-1
    tags = {
        Name = "DB-Subnet-1"
    }
}
resource "aws_subnet" "private-6" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.8.0/24"
    availability_zone = var.az-2
    tags = {
        Name = "DB-Subnet-2"
    }
}

resource "aws_eip" "elastic-ip" {
  
}

resource "aws_nat_gateway" "dev-nat" {
    allocation_id = aws_eip.elastic-ip.id
    subnet_id = aws_subnet.public-1.id
    tags = {
      Name = "dev-nat"
    }
}

resource "aws_route_table" "private-rt" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.dev-nat.id
    }
    tags = {
      Name = "private-rt"
    }
}

resource "aws_route_table_association" "private-1" {
    subnet_id = aws_subnet.private-1.id
    route_table_id = aws_route_table.private-rt.id  
}
resource "aws_route_table_association" "private-2" {
    subnet_id = aws_subnet.private-2.id
    route_table_id = aws_route_table.private-rt.id  
}
resource "aws_route_table_association" "private-3" {
    subnet_id = aws_subnet.private-3.id
    route_table_id = aws_route_table.private-rt.id  
}
resource "aws_route_table_association" "private-4" {
    subnet_id = aws_subnet.private-4.id
    route_table_id = aws_route_table.private-rt.id  
}
resource "aws_route_table_association" "private-5" {
    subnet_id = aws_subnet.private-5.id
    route_table_id = aws_route_table.private-rt.id  
}
resource "aws_route_table_association" "private-6" {
    subnet_id = aws_subnet.private-6.id
    route_table_id = aws_route_table.private-rt.id  
}