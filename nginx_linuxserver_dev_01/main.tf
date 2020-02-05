provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "linux_server_dev_01" {
  instance_type = "t2.micro"
  ami           = "ami-02ccb28830b645a41"

  tags = {
    Name = "linux_server_dev_01"
  }

  vpc_security_group_ids = [aws_security_group.linux_server_dev_01_sg.id]

  user_data = <<-EOF
              #!bin/bash
              sudo amazon-linux-extras install nginx1.12 -y
              sudo service nginx start
              EOF

}

resource "aws_security_group" "linux_server_dev_01_sg" {
  name = "linux_server_dev_01_sg"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
