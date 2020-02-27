# vpc
provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "vpc_main_1" {
  cidr_block = "10.0.0.0/16"
  enabled_dns_hostnames = true

  tags = {
    Name = "vpc_main_1"
  }

}
