# directory_service

resource "aws_directory_services_directory" "COURSE_AD" {
	name = var.domain_name
	password = "infraPassword123"

	edition = "Standar"
	description = "Infra AD"

	vpc_settings {
		vpc_id = aws_vpc.COURSE_VPC.id

		subnet_ids = [aws_subnet.COURSE_PRIVATE_SUBNET.id, aws_subnet.COURSE_PUBLIC_SUBNET.id]
	}

	type = var.dir_type

	lifecycle {
		ignore_changes = [
			edition,
		]
	}
}

