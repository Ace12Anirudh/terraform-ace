#------------------------------------------------------------------------------
# Global & Project Variables
#------------------------------------------------------------------------------
variable "project_name" {
  description = "The name of the project, used for tagging resources."
  type        = string
  default     = "webapp"
}

variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "The AWS region to deploy the resources in."
  type        = string
  default     = "us-east-1"
}

#------------------------------------------------------------------------------
# Networking Variables
#------------------------------------------------------------------------------
variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "A list of Availability Zones to use."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "A list of CIDR blocks for the public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "A list of CIDR blocks for the private subnets. Should be 3x the number of AZs."
  type        = list(string)
  default     = [
    # AZ 1 Subnets
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24",
    # AZ 2 Subnets
    "10.0.201.0/24",
    "10.0.202.0/24",
    "10.0.203.0/24"
  ]
}

#------------------------------------------------------------------------------
# Security Variables
#------------------------------------------------------------------------------
variable "my_ip" {
  description = "Your local IP address to allow SSH access to the bastion host. IMPORTANT: Change this to your real IP."
  type        = string
  default     = "0.0.0.0/0" # WARNING: This is insecure. Replace with your IP.
}