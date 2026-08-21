provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "demo" {
  ami           = "ami-0ad21ae1d0696ad58"
  instance_type = "t2.micro"

  tags = {
    Name = "demo-ec2"
  }
}

resource "aws_vpc" "publicvpc"{
cidr_block ="10.0.0.0/16" 

tags={
name="dev-vpc"
}

}
