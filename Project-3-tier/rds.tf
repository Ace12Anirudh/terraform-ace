resource "aws_db_subnet_group" "db-subnet" {
    name = "dbsubnet"
    subnet_ids = [aws_subnet.private-5.id, aws_subnet.private-6.id]
    depends_on = [ aws_subnet.private-5, aws_subnet.private-5 ]

    tags = {
      Name ="DB-Subnet"
    }
}   

resource "aws_db_instance" "rds" {
    allocated_storage = 20
    identifier = "book-rds"
    db_subnet_group_name = aws_db_subnet_group.db-subnet.id
    engine = "mysql"
    engine_version = "8.0"
    multi_az = true
    username = "admin"
    password = "cloud123"
    skip_final_snapshot = true
    instance_class = "db.t3.micro"
    depends_on = [aws_db_subnet_group.db-subnet]
    publicly_accessible = false
    backup_retention_period = 7
    vpc_security_group_ids = [aws_security_group.RDS-sg.id]
  
}