# Bastion Host
resource "aws_security_group" "bastion-host" {
  name = "app-server-sg"
  description = "Allow Developer From SSH"
  vpc_id = aws_vpc.vpc.id
  depends_on = [ aws_vpc.vpc ]

  ingress {
    description = "Allow Traffic From Developer"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.my_ip] # my ip in terraform.tfvars
  } 

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Bastion-SG"
  }
}

# Internet Facing AlB (Frontend)
resource "aws_security_group" "alb-frontend-sg" {
    name = "alb-frontend-sg"
    description = "Allow HTTP/ HTTPS"
    vpc_id = aws_vpc.vpc.id
    depends_on = [aws_vpc.vpc]

    ingress {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "HTTPS"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "ALB-Frontend-SG"
    }
}

# Internet Facing AlB (Frontend)
resource "aws_security_group" "alb-backend-sg" {
    name = "alb-backend-sg"
    description = "Allow HTTP / MySQL"
    vpc_id = aws_vpc.vpc.id
    depends_on = [aws_vpc.vpc]

    ingress {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "ALB-Frontend-SG"
    }
}

# frontend server sg
resource "aws_security_group" "frontend-sg" {
    name        = "frontend-server-sg"
    description = "Allow inbound traffic "
    vpc_id      = aws_vpc.vpc.id
    depends_on = [ aws_vpc.vpc,aws_security_group.alb-frontend-sg ]

    ingress {
        description     = "http"
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        security_groups = [aws_security_group.alb-frontend-sg.id]
    }
    ingress {
        description     = "ssh"
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        security_groups = [aws_security_group.bastion-host.id]

    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "frontend-sg"
    }
}

# Backend server sg
resource "aws_security_group" "backend-sg" {
    name        = "backend-server-sg"
    description = "Allow SSH traffic from bastion"
    vpc_id      = aws_vpc.vpc.id
    depends_on = [ aws_vpc.vpc,aws_security_group.alb-frontend-sg ]

    ingress {
        description     = "ssh"
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        security_groups = [aws_security_group.bastion-host.id]

    }

    ingress {
        description     = "http"
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        security_groups = [aws_security_group.alb-backend-sg.id]

    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "backend-sg"
    }
}

# Mysql Arora sg
resource "aws_security_group" "RDS-sg" {
    name        = "RDS-sg"
    description = "Allow Backend traffic to RDS"
    vpc_id      = aws_vpc.vpc.id
    depends_on = [ aws_vpc.vpc,aws_security_group.backend-sg ]

    ingress {
        description     = "mysql"
        from_port       = 3306
        to_port         = 3306
        protocol        = "tcp"
        security_groups = [aws_security_group.backend-sg.id]
    }

    ingress {
        description     = "mysql"
        from_port       = 3306
        to_port         = 3306
        protocol        = "tcp"
        security_groups = [aws_security_group.bastion-host.id]
    }

    ingress {
        description     = "SSH"
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        security_groups = [aws_security_group.bastion-host.id]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "rds-sg"
    }
}