resource "aws_instance" "dev" {
    ami = "ami-0bdd88bd06d16ba03"
    instance_type = "t2.micro"
    tags = {
      Name = "dev"
    }

    lifecycle {
      create_before_destroy = true
    }

    # lifecycle {
    #   ignore_changes = [ tags ,  ]
    # }

    # lifecycle {
    #   prevent_destroy = true
    # }
}


#target resource we can user to apply specific resource level only belwo command is the reference 
#terraform apply -target=aws_s3_bucket.name

#try skip resource 
    