provider "aws" {
    region = "us-east-1"

  
}
provider "aws" {
    region = "us-west-2"
    alias = "oregon"
    profile = "dev"
  
}
# use the profile configure command : aws configure --profile dev