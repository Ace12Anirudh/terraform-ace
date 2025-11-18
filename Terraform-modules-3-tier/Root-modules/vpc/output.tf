#------------------------------------------------------------------------------
# VPC and Subnet Outputs
#------------------------------------------------------------------------------
output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC."
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "A list of IDs for the public subnets."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "A list of IDs for the private subnets."
  value       = aws_subnet.private[*].id
}

#------------------------------------------------------------------------------
# Security Group Outputs
#------------------------------------------------------------------------------
output "bastion_sg_id" {
  description = "The ID of the Bastion Host security group."
  value       = aws_security_group.bastion.id
}

output "frontend_alb_sg_id" {
  description = "The ID of the Frontend ALB security group."
  value       = aws_security_group.frontend_alb.id
}

output "backend_alb_sg_id" {
  description = "The ID of the Backend ALB security group."
  value       = aws_security_group.backend_alb.id
}

output "frontend_server_sg_id" {
  description = "The ID of the Frontend Server security group."
  value       = aws_security_group.frontend_server.id
}

output "backend_server_sg_id" {
  description = "The ID of the Backend Server security group."
  value       = aws_security_group.backend_server.id
}

output "rds_sg_id" {
  description = "The ID of the RDS Database security group."
  value       = aws_security_group.rds.id
}