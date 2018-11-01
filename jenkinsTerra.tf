provider "aws"{
  profile = "default"
  region = "us-east-2"
}

#VPC
resource "aws_vpc" "publicVpc"{
  cidr_block = "10.20.0.0/16"
  tags {
    Name = "publicVpc"
  }
}

#IGW

resource "aws_internet_gateway" "publicigw"{
  vpc_id = "${aws_vpc.publicVpc.id}"
  tags {
    Name = "publicIgw"
  }
}

#route table

resource "aws_route_table" "publicRoute"{
  vpc_id = "${aws_vpc.publicVpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.publicigw.id}"
  }
  tags {
    Name = "publicRoute"
  }
}

#security group
resource "aws_security_group" "allowalltest"{
  vpc_id = "${aws_vpc.publicVpc.id}"

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "publicSg"
  }
}

#subnet
resource "aws_subnet" "subnetpublic" {
  vpc_id = "${aws_vpc.publicVpc.id}"
  cidr_block = "10.20.5.0/24"
  tags {
    Name = "publicSUbnet"
  }
}

#instance create
resource "aws_instance" "Instanec" {
  ami = "ami-0b59bfac6be064b78"
  instance_type = "t2.micro"
  tags {
    Name = "terraform"
  }
  vpc_security_group_ids = "${aws_security_group.allowalltest.id}"
  subnet_id = "${aws_subnet.subnetpublic.id}"
  associate_public_ip_address = "true"
}

output "ip instance"{
  value = "${aws_instance.Instanec.public_ip}"
}
