output "public_ip" {
    value = aws_instance.name.public_ip
  
}

output "az" {
    value = aws_instance.name.availability_zone
  
}

output "private_ip" {
    value = aws_instance.name.private_ip
  
}

output "cidr" {
    value = aws_vpc.name.cidr_block
  
}