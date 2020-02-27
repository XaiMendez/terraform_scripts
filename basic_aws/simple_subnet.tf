# subnet
# az = availability zone
# VPC
#   -subnet az
#   -subnet az

resource "aws_subnet" "subnet_main_1" {
  vpc_id = "${aws_vpc.vpc_main_1.id}"
  cidr_block = "10.0.10.0/24"
  map_pubic_ip_on_launch = true
  availability_zone = "us-east-2a"

  tags = {
    Name = "subnet_main_1"
  }

}

resource "aws_subnet" "subnet_main_2" {
  vpc_id = "${aws_vpc.vpc_main_1.id}"
  cidr_block = "10.0.20.0/24"
  map_pubic_ip_on_launch = true
  availability_zone = "us-east-2b"

  tags = {
    Name = "subnet_main_2"
  }

}

resource "aws_subnet" "subnet_main_3" {
  vpc_id = "${aws_vpc.vpc_main_1.id}"
  cidr_block = "10.0.30.0/24"
  map_pubic_ip_on_launch = true
  availability_zone = "us-east-2c"

  tags = {
    Name = "subnet_main_3"
  }

}


# IG to VPC, 
# subnet a route table

# internet gateway
resource "aws_internet_gateway" "ig_main_1" {
  vpc_id = "${aws_vpc.vpc_main_1.id}"

  tags = {
    Name = "ig_main_1"
  }

}

# route table
resource "aws_route_table" "rt_main_1" {
  vpc_id = "${aws_vpc.vpc_main_1.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ig_main_1.id}"
  }
}


# Associations
resource "aws_route_table_association" "rta_subnet_main_1" {
  subnet_id = "${aws_subnet.subnet_main_1.id}"
  route_table_id = "${aws_route_table.rt_main_1.id}" 
}

resource "aws_route_table_association" "rta_subnet_main_2" {
  subnet_id = "${aws_subnet.subnet_main_2.id}"
  route_table_id = "${aws_route_table.rt_main_1.id}" 
}

resource "aws_route_table_association" "rta_subnet_main_3" {
  subnet_id = "${aws_subnet.subnet_main_3.id}"
  route_table_id = "${aws_route_table.rt_main_1.id}" 
}
