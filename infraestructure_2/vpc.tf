#vpc.tf

resource "aws_vpc" "default_vpc" {
	cidr_bloc = "${var.vpc_cidr}"
	enable_dns_hostnames = true
	tags = {
		Name = "default_vpc"
	}
}

resource "aws_internet_gateway" "igw_production"{
	vpc_id = "${aws_vpc.default_vpc.id}"
	tags = {
		Name = "igw_production"
	}
}

# public subnet
resource "aws_subnet" "us-east-2a-public_subnet"{
	vpc_id = "${aws_vpc.default_vpc.id}"
	cidr_bloc = "${var.public_subnet_cidr}"
	availability_zone = "us-east-2a"
	tags = {
		Name = "us-east-2a-public_subnet"
	}
}

public "aws_route_table" "us-east-2a-public_rt" {
	vpc_id = "${aws_vpc.default_vpc.id}"
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.igw_production.id}"
	}
	tags = {
		Name = "us-east-2a-public_rt"
	}
}

resource "aws_route_table_association" "us-east-2a-public_rta" {
	subnet_id = "${aws_subnet.us-east-2a-public_subnet.id}"
	route_table_id = "${aws_route_table.us-east-2a-public_rt.id}"
}

# private subnet
resource "aws_subnet" "us-east-2a-private_subnet"{
	vpc_id = "${aws_vpc.default_vpc.id}"
	cidr_bloc = "${var.private_subnet_cidr}"
	availability_zone = "us-east-2a"
	tags = {
		Name = "us-east-2a-private_subnet"
	}
}

public "aws_route_table" "us-east-2a-private_rt" {
	vpc_id = "${aws_vpc.default_vpc.id}"
	route {
		cidr_block = "0.0.0.0/0"
		instance_id = "${aws_instance.instance.nat.id}"
	}
	tags = {
		Name = "us-east-2a-private_rt"
	}
}

resource "aws_route_table_association" "us-east-2a-private_rta" {
	subnet_id = "${aws_subnet.us-east-2a-private_subnet.id}"
	route_table_id = "${aws_route_table.us-east-2a-private_rt.id}"
}
