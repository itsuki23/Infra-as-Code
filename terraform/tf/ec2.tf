# ------------------------------
#  Var
# ------------------------------

# prefix = climb

# ec2_1a ip = 10.1.10.10
# ec2_1c ip = 10.1.11.10
# ec2_1a az = ap-northeast-1a
# ec2_1c az = ap-northeast-1c



# ------------------------------
#  ec2
# ------------------------------

resource "aws_instance" "ec2_1a" {
  key_name          = "raise"
  ami               = "ami-0af1df87db7b650f4"
  instance_type     = "t2.micro"
  availability_zone = "ap-northeast-1a"
  subnet_id         = aws_subnet.public_1a.id
  security_groups   = [aws_security_group.ec2.id]
  private_ip        = "10.1.10.10"
  ebs_optimized     = false
  monitoring        = false
  source_dest_check = false
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = false
  }
  tags = { "Name" = "climb-ec2-1a" }
}
output "EC2_1a_public_IP" {
  value = aws_instance.ec2_1a.public_ip
}



resource "aws_instance" "ec2_1c" {
  key_name          = "raise"
  ami               = "ami-0af1df87db7b650f4"
  instance_type     = "t2.micro"
  availability_zone = "ap-northeast-1c"
  subnet_id         = aws_subnet.public_1c.id
  security_groups   = [aws_security_group.ec2.id]
  private_ip        = "10.1.11.10"
  ebs_optimized     = false
  monitoring        = false
  source_dest_check = false
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = false
  }
  tags = { "Name" = "climb-ec2-1c" }
}
output "EC2_1c_public_IP" {
  value = aws_instance.ec2_1c.public_ip
}
# associate_public_ip_address = true
#  ↪︎ apply時の差分によるエラーが出るらしい
#    subnetのmap_public_ip_on_launchで補完



# ------------------------------
#  SecurityGroup
# ------------------------------

resource "aws_security_group" "ec2" {
  name        = "climb-ec2-sg"
  description = "Allow ssh http https"
  vpc_id      = aws_vpc.public.id

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
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
