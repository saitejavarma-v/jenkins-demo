provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "demo" {
  ami           = "ami-0ad21ae1d0696ad58"
  instance_type = "t2.micro"
   subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]


  tags = {
    Name = "demo-ec2"
  }
}

resource "aws_vpc" "publicvpc"{
cidr_block ="10.0.0.0/16" 

tags={
name="dev-vpc1"
}

}

resource "aws_subnet" "public_subnet"{
vpc_id=aws_vpc.publicvpc.id
  region = "ap-south-1"
cidr_block ="10.0.0.0/16" 

tags={
name="dev-vpc2"
}
}
 resource "aws_internet_gateway" "public_igw" {
vpc_id=aws_vpc.publicvpc.id

tags={
name="dev-vpc3"
}
 }

resource "aws_route_table" "public_route_table"{
vpc_id=aws_vpc.publicvpc.id
gateway_id=aws_internetgateway.public_igw.id
tags={
name="dev-vpc4"
}
}

resource "aws_route" "connect_igw_and_route_table" {
route_table_id=aws_routetable.public_routetable.id


}

resource "aws_route_table_association" "routetable_with_subnet" {
route_table_id=aws_route_table.public_route_table.id
subnet_id= aws_subnet.public_subnet.id
tags={
name="dev-vpc6"
}
}

resource "aws_security_group" "public_sg" {
  name   = "public-sg"
  vpc_id = aws_vpc.publicvpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dev-vpc7"
}
}








