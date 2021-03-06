resource "aws_vpc" "DEV_01_VPC"{
	cidr_block 				= var.vpc_cidr
	enable_dns_hostnames 	= true
	tags = merge(
	{
		"Name" = "${local.name_prefix}-VPC"
	},
	local.default_tags
	)
}

resource "aws_internet_gateway" "DEV_01_IGW" {
	vpc_id = aws_vpc.DEV_01_VPC.id
	tags = merge({
		"Name" = "${local.name_prefix}-IGW"
	},
	local.default_tags,
	)
}

resource "aws_subnet" "DEV_01_PUBLIC_SUBNET" {
	map_public_ip_on_launch = true
	availability_zone = element(var.az_names, 0)
	vpc_id = aws_vpc.DEV_01_VPC.id
	cidr_block = element(var.subnet_cidr_blocks, 0)
	tags = merge({
		"Name" = "${local.name_prefix}-SUBNET-AZ-A"
	},
	local.default_tags,
	)
}


resource "aws_subnet" "DEV_01_PRIVATE_SUBNET" {
	map_public_ip_on_launch = false
	availability_zone = element(var.az_names, 1)
	vpc_id = aws_vpc.DEV_01_VPC.id
	cidr_block = element(var.subnet_cidr_blocks, 1)
	tags = merge({
		"Name" = "${local.name_prefix}-SUBNET-AZ-B"
	},
	local.default_tags,
	)
}

resource "aws_eip" "APP_EIP" {
}

resource "aws_nat_gateway" "DEV_01_NAT" {
	subnet_id = aws_subnet.DEV_01_PUBLIC_SUBNET.id
	allocation_id = aws_eip.APP_EIP.id
	tags = merge({
		"Name" = "${local.name_prefix}-NGW"
	},
	local.default_tags,
	)
}

resource "aws_route_table" "DEV_01_PUBLIC_ROUTE" {
	vpc_id = aws_vpc.DEV_01_VPC.id
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.DEV_01_IGW.id
	}
	tags = merge({
		"Name" = "${local.name_prefix}-PUBLIC-RT"
	},
	local.default_tags,
	)
}

resource "aws_route_table" "DEV_01_PRIVATE_ROUTE" {
	vpc_id = aws_vpc.DEV_01_VPC.id
	route {
		cidr_block = "0.0.0.0/0"
		nat_gateway_id = aws_nat_gateway.DEV_01_NAT.id
	}
	tags = merge({
		"Name" = "${local.name_prefix}-PRIVATE-RT"
	},
	local.default_tags,
	)
}

resource "aws_vpc_endpoint" "DEV_01_S3_ENDPOINT" {
	vpc_id = aws_vpc.DEV_01_VPC.id
	service_name = "com.amazonws.${var.aws_region}.s3"
	route_table_ids = [aws_route_table.DEV_01_PUBLIC_ROUTE.id, aws_route_table.DEV_01_PRIVATE_ROUTE.id]
}

resource "aws_route_table_association" "PUBLIC_ASSO" {
	route_table_id = aws_route_table.DEV_01_PUBLIC_ROUTE.id
	subnet_id = aws_subnet.DEV_01_PUBLIC_SUBNET.id
}

resource "aws_route_table_association" "PRIVATE_ASSO" {
	route_table_id = aws_route_table.DEV_01_PRIVATE_ROUTE.id
	subnet_id = aws_subnet.DEV_01_PUBLIC_SUBNET.id
}

# Restringir puertos, acceso de infraesructura a traves de la red
resource "aws_network_acl" "DEV_01_NACL" {
	vpc_id = aws_vpc.DEV_01_VPC.id
	subnet_ids = [aws_subnet.DEV_01_PUBLIC_SUBNET.id, aws_subnet.DEV_01_PRIVATE_SUBNET.id]

	ingress{
		protocol = "tcp"
		rule_no = 110
		action = "deny"
		cidr_block = "0.0.0.0/0"
		from_port = 23
		to_port = 23
	}

	ingress{
		protocol = "tcp"
		rule_no = 32766
		action = "allow"
		cidr_block = "0.0.0.0/0"
		from_port = 0
		to_port = 0
	}

	egress{
		protocol = "tcp"
		rule_no = 110
		action = "deny"
		cidr_block = "0.0.0.0/0"
		from_port = 23
		to_port = 23
	}

	egress{
		protocol = "tcp"
		rule_no = 32766
		action = "allow"
		cidr_block = "0.0.0.0/0"
		from_port = 0
		to_port = 0
	}

	tags = merge({
		"Name" = "${local.name_prefix}-NACL"
	},
	local.default_tags,
	)
}


# security group
resource "aws_security_group" "APP_ALB_SG" {
	vpc_id = aws_vpc.DEV_01_VPC.id
	name = "${local.name_prefix}-ALB-SG"

	ingress{
		protocol = "tcp"
		from_port = 80
		to_port = 80
		security_groups = [aws_security_group.APP_SG.id]
	}

	ingress{
		protocol = "tcp"
		from_port = 443
		to_port = 443
		security_groups = [aws_security_group.APP_SG.id]
	}

	egress{
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = merge({
		"Name" = "${local.name_prefix}-ALB-SG"
	},
	local.default_tags,
	)

}


# security group
resource "aws_security_group" "APP_SG" {
	vpc_id = aws_vpc.DEV_01_VPC.id
	name = "${local.name_prefix}-APP-SG"

	ingress{
		protocol = "tcp"
		from_port = 22
		to_port = 22
		cidr_blocks = [aws_vpc.DEV_01_VPC.cidr_block]
	}

	ingress {
		protocol = "tcp"
		from_port = 3389
		to_port = 3389
		cidr_blocks = [aws_vpc.DEV_01_VPC.cidr_block]
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = merge({
		"Name" = "${local.name_prefix}-APP-SG"
	},
	local.default_tags,
	)

}
