# Key Pair
resource "aws_key_pair" "example" {
  key_name   = "task"
  public_key = file("my-keypair.pub")
}


resource "aws_instance" "server" {
  ami                         = "ami-0261755bbcb8c4a84" # Ubuntu AMI
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.example.key_name
  tags = {
    Name = "server"
  }
  
}