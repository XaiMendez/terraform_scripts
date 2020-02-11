# rds
# database service
# subnet group
# database
# version
# highly available
# security group

resource "aws_db_subnet_group" "Postgres_DB_Subnet_Group" {
	name = "${lower(local.name_prefix)-subnet-group}"

	subnet_ids = [aws_subnet.COURSE_PRIVATE_SUBNET.id, aws_subnet.COURSE_PUBLIC_SUBNET.id]

	tags = merge({
		"Name" = "${local.name_prefix}-SUBNET-GROUP"
	},
	local.default_tags,
	)
}

resource "aws_db_instance" "Postgres_DB_Instance" {
	allocated_storage = var.allocated_storage
	storage_type = "gp2"
	engine = var.engine
	engine_version = var.engine_version
	instance_class = var.instance_type
	name = var.db_name
	username = var.username
	password = var.password
	identifier = "${lower(local.name_prefix)}-rds"
	storage_encrypted = true
	vpc_security_groups_ids = [aws_security_group.APP_SG.id]
	db_subnet_group_name = aws_db_subnet_group.Postgres_DB_Subnet_Group.id
	multi_az = true
	skip_final_snapshot = true

	tags = merge({
		"Name" = "${local.name_prefix}-RDS"
	},
	local.default_tags,
	)

}
