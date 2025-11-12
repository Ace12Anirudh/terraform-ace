resource "aws_instance" "bastion" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = "ace-key"
    subnet_id = aws_subnet.public-1.id
    vpc_security_group_ids = [aws_security_group.bastion-host.id ]
    tags = {
      Name= "bastion-server"
    }
    associate_public_ip_address =true
    depends_on = [ aws_db_instance.rds ]
    user_data = templatefile("${path.module}/rds_data.sh",{
        DB_HOST = aws_db_instance.rds.address
        DB_USER = "admin"
        DB_PASS = "cloud123"
    })

    user_data_replace_on_change = true
}
