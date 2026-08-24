
resource "aws_vpc" "publicvpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "dev-vpc1"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.publicvpc.id

  # 🔴 CHANGE
  cidr_block = var.subnet.prefix

  # 🔴 ADD
  availability_zone = "ap-south-1a"

  # 🔴 ADD
  map_public_ip_on_launch = true

  tags = {
    Name = "dev-vpc2"
  }
}


# 🔴 CHANGE resource name
resource "aws_internet_gateway" "public_igw" {
  vpc_id = aws_vpc.publicvpc.id

  tags = {
    Name = "dev-vpc3"
  }
}


# 🔴 CHANGE resource name
resource "aws_route_table" "public_routetable" {
  vpc_id = aws_vpc.publicvpc.id

  tags = {
    Name = "dev-vpc4"
  }
}

variable "subnet_prefix" {
description="jst passing the values"

}


resource "aws_route" "connect_igw_and_routetable" {

  # 🔴 CHANGE reference
  route_table_id = aws_route_table.public_routetable.id

  # 🔴 ADD
  destination_cidr_block = "0.0.0.0/0"

  # 🔴 ADD
  gateway_id = aws_internet_gateway.public_igw.id
}


# 🔴 CHANGE resource name
resource "aws_route_table_association" "routetable_with_subnet" {

  # 🔴 CHANGE reference
  route_table_id = aws_route_table.public_routetable.id

  subnet_id = aws_subnet.public_subnet.id
}


resource "aws_security_group" "public_sg" {

  # 🔴 ADD
  name = "public-sg"

  # 🔴 ADD
  vpc_id = aws_vpc.publicvpc.id

  # 🔴 ADD
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 🔴 ADD
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 🔴 ADD
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


resource "aws_instance" "demo" {
  ami           = "ami-0ad21ae1d0696ad58"
  instance_type = "t2.micro"

  # 🔴 ADD — puts EC2 inside your subnet
  subnet_id = aws_subnet.public_subnet.id

  # 🔴 ADD — attaches your SG to EC2
  vpc_security_group_ids = [aws_security_group.public_sg.id]

  tags = {
    Name = "demo-ec2"
  }
}
