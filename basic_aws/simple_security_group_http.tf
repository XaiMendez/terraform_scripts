# simple_security_group_http.tf

resource "aws_security_group" "sg_main_http" {
  name        = "sg_allow_ping_http"
  description = "Allow ping http"
  vpc_id      = "${aws_vpc.vpc_main_1.id}"

  #ssh
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #ping
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "sg_main_http"
  }

}
