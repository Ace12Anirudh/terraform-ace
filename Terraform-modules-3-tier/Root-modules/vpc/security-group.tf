#------------------------------------------------------------------------------
# Bastion Host Security Group
#------------------------------------------------------------------------------
resource "aws_security_group" "bastion" {
  name        = "${var.project_name}-bastion-sg"
  description = "Allow SSH access from my IP"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from My IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.project_name}-bastion-sg" })
}

#------------------------------------------------------------------------------
# Frontend Application Load Balancer (ALB) Security Group
#------------------------------------------------------------------------------
resource "aws_security_group" "frontend_alb" {
  name        = "${var.project_name}-frontend-alb-sg"
  description = "Allow HTTP/HTTPS traffic from the internet"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.project_name}-frontend-alb-sg" })
}

#------------------------------------------------------------------------------
# Frontend Server Security Group
#------------------------------------------------------------------------------
resource "aws_security_group" "frontend_server" {
  name        = "${var.project_name}-frontend-server-sg"
  description = "Allow traffic from Frontend ALB and Bastion"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow traffic from Frontend ALB"
    from_port       = 80 # Or your application port, e.g., 3000
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_alb.id]
  }

  ingress {
    description     = "Allow SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.project_name}-frontend-server-sg" })
}

#------------------------------------------------------------------------------
# Backend Application Load Balancer (ALB) Security Group
#------------------------------------------------------------------------------
resource "aws_security_group" "backend_alb" {
  name        = "${var.project_name}-backend-alb-sg"
  description = "Allow traffic only from frontend servers"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow traffic from frontend servers"
    from_port       = 8080 # Example port for internal API
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_server.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.project_name}-backend-alb-sg" })
}

#------------------------------------------------------------------------------
# Backend Server Security Group
#------------------------------------------------------------------------------
resource "aws_security_group" "backend_server" {
  name        = "${var.project_name}-backend-server-sg"
  description = "Allow traffic from Backend ALB and Bastion"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow traffic from Backend ALB"
    from_port       = 8080 # Or your application port, e.g., 5000
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_alb.id]
  }

  ingress {
    description     = "Allow SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.project_name}-backend-server-sg" })
}

#------------------------------------------------------------------------------
# RDS Database Security Group
#------------------------------------------------------------------------------
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg"
  description = "Allow traffic only from backend servers"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow PostgreSQL traffic from backend servers"
    from_port       = 5432 # Port for PostgreSQL, change if using another DB
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_server.id]
  }

  # Egress is typically not needed for a DB to respond, but leaving as all is safe within a VPC
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.project_name}-rds-sg" })
}