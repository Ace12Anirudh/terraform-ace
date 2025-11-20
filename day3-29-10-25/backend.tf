terraform {
  backend "s3" {
    bucket = "ace-12-terra-bucketttt"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
