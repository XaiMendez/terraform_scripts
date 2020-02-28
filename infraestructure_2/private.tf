# private.tf

resource "aws_security_group" "sg_db" {
	name = "vpc_db"

	ingress = {
		from_port = 1433
		to_port = 1433
		security_groups
	}
}


resource "aws_instance" "db_1" {
	ami = "${lookup(var.amis, var.region)}"

	availability_zone = "us-east-2"
	instance_type = "t2.micro"

	key_name = 
	vpc_security_groups_id = ["aws_security_group.sg_db.id"]
	

}

