variable "my_ip" {
    default = ""
    description = "value"
    type = string
}

variable "ami" {
    description = "ami"
    type = string
    default = "ami-0157af9aea2eef346"  
}

variable "instance_type" {
    description = "instance_type"
    type = string
    default = "t2.micro"
}

variable "az-1" {
    description = "first availability zone"
    type = string
    default = "us-east-1a"
}

variable "az-2" {
    description = "second availability zone"
    type = string
    default = "us-east-1b"
}