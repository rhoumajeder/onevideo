# VPC
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "flask-app-vpc"
  }
}

resource "aws_security_group" "example" {
  name        = "example"
  description = "Allow SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
   ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}

resource "aws_instance" "example" {
  count = 3
  ami           = "ami-086df58ea1b1ad56a"
  instance_type = "t3.small"
  key_name      = "RjeKeys"
  
  vpc_security_group_ids = [aws_security_group.example.id]
  
    tags = {
    Name = "FlaskApp"
  }
  
 

}


# Subnet
resource "aws_subnet" "this" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.subnet_cidr_block
  map_public_ip_on_launch = true

  tags = {
    Name = "flask-app-subnet"
  }
  



}

 output "ip_address" {
  #value = aws_instance.example.public_ip
  value = {
    server_1 = aws_instance.example[0].public_ip
    server_2 = aws_instance.example[1].public_ip
    server_3 = aws_instance.example[2].public_ip
  }
  
 
  

}

data "aws_route53_zone" "example" {
  name         = "jedder.net."
  private_zone = false
}

resource "aws_route53_record" "example" {
  zone_id = data.aws_route53_zone.example.zone_id
  name    = "jedder.net."
  type    = "A"
  ttl     = "300"
  records = [aws_instance.example[0].public_ip]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "www_example" {
  zone_id = data.aws_route53_zone.example.zone_id
  name    = "www.jedder.net."
  type    = "A"
  ttl     = "300"
  records = [aws_instance.example[0].public_ip]

  lifecycle {
    create_before_destroy = true
  }
}



