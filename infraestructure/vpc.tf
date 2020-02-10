resource "aws_vpc" "COURSE_VPC"{
	cidr_block 				= var.vpc_cidr
	enable_dns_hostnames 	= true
	default_tags= merge({
		"Name" = "${local.name_prefix}-VPC"
	},
	local.default_tags,
	)
}

resource "aws_internet_gateway" "COURSE_IGW" {
	vpc_id = aws_vpc.COURSE_VP.id
	tags = merge({
		"Name" = "${local.name_prefix}-IGW"
	},
	local.default_tags,
	)
}

resource "aws_subnet" "COURSE_PUBLIC_SUBNET {
	map_public_ip_on_launch = true
	avilability_zone = element(var.az_name, 0)
	vpc_id = aws_vpc_COURSE_VPC.id
	cidr_block = var.element(var.subnet_cidr_blocks, 0)
	tags = merge({
		"Name" = "${local.name_prefix}-SUBNET-AZ-A"
	},
	local.default_tags,
	)
}


resource "aws_subnet" "COURSE_PRIVATE_SUBNET {
	map_public_ip_on_launch = false
	avilability_zone = element(var.az_name, 1)
	vpc_id = aws_vpc_COURSE_VPC.id
	cidr_block = var.element(var.subnet_cidr_blocks, 1)
	tags = merge({
		"Name" = "${local.name_prefix}-SUBNET-AZ-B"
	},
	local.default_tags,
	)
}

resource "aws_eip" "APP_EIP" {
}

resource "aws_nat_gateway" "COURSE_NAT" {
	subnet_id = aws.subnet.COURSE_PUBLIC_SUBNET.id
	allocation_id = aws_eip.APP_EIP.id
	tags = merge({
		"Name" = "${local.name_prefix}-NGW"
	},
	local.default_tags,
	)
}

resource "aws_route_table" "COURSE_PUBLIC_ROUTE" {
	vpc_id = aws.vpc_COURSE_VPC.id
	route {
		cidr_block = "0.0.0.0/0",
		gateway_id = aws.interner_gateway.COURSE_IGW.id
	}
	tags = merge({
		"Name" = "${local.name_prefix}-PUBLIC-RT"
	},
	local.default_tags,
	)
}
