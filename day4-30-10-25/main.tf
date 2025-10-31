resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "Ace-vpc"
    } 
}

resource "aws_s3_bucket" "example" {
  bucket = "give-me-anice-bucket"
}
