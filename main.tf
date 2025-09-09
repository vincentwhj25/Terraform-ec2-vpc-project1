# VPC
resource "aws_vpc" "main" {
  cidr_block = "172.32.0.0/16"
  tags = { Name = "main-vpc" }
}

#Internet GW
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "SG-igw" }
}

#Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = { Name = "public-rt" }
}

# Subnet
resource "aws_subnet" "main" {
  vpc_id             = aws_vpc.main.id
  cidr_block         = "172.32.1.0/24"
  availability_zone  = "${var.region}a"
  tags = { Name = "private_subnet_172.32.1.0/24" }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.public.id
}

# Security Group
resource "aws_security_group" "allow_ssh" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "allow-ssh" }
}

# EC2 Instance
resource "aws_instance" "web" {
  ami                    = "ami-0779c82fbb81e731c"
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true  

  tags = { Name = "terraform-ec2" }
}
