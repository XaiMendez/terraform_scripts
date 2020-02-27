provider "aws" {
  region = ""
  access_key = ""
  secret_key = ""
}

resource "aws_instance" "test_instance" {
  ami = "ami-5678098345679876"
  instance_type = "t2-micro"
}
