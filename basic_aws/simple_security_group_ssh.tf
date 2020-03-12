# simple_security_group_ssh.tf

resource "aws_security_group" "sg_main_ssh" {
  name        = "sg_allow_ping_ssh"
  description = "Allow ping ssh"
  vpc_id      = "${aws_vpc.vpc_main_1.id}"

  #ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #ping
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "sg_main_ssh"
  }

}
