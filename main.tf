provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "demo" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"

  tags = {
    Name = "demo-ec2"
  }
}
