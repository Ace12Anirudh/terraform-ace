provider "aws" {
  
}
resource "aws_s3_bucket" "name" {
    bucket = "newbucket-ace-cloudee"
  
}

# terraform workspace new ace
# you can select between multiple workspace by "select" command, you can "delete" , you can check "list" , and "show"