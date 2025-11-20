terraform {
  backend "s3" {
    bucket = "ace-12-terra-bbbbbuckettttt"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
