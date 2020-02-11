#auto scalling group
# aws ami
# private ip
# launch configuration
# instance profile
# key pairs
# target group attach


# private key
resource "tls_private_key" "app_private_key" {
	
	algorithm = "RSA"
	rsa_bits = 4096
}

# key pair for instances
resource "aws_key_pair" "generated_key" {
	key_name = "APP-KEY"
	public_key = tls_private_key.app_private_key.public_key_opessh
}


# get most recent image
data "aws_ami" "ubuntu" {
	most_recent = true
	owners = ["amazon"]

	filter{
		name = "name"
		value = ["ubuntu-bionic-18.04-amd64-server.*"]
	}
}


# launch configuration fot image
resource "aws_launch_configuration" "app_launch_configuration" {
	name_prefix = "${local.name_prefix}-APP-LC"
	image_id = data.aws_ami.ubuntu.image_id
	instance_type = var.instance_type
	#user_data = ""
	associate_public_ip_address = false
	iam_instance_profile = aws_iam_instance_profile.app_instance_profile.name
	security_groups = ["aws_security_group.APP_SG.id"]
	key_name = aws_key_pair.generated_key.key_name

	root_block_device{
		volume_size = "60"
		volume_type = "gp2"
		delete_on_termination = true
	}

	lifecycle{
		create_before_destroy = true
	}


}


resource "aws_autoscalling_group" "app_asg" {
	name_prefix = "${local.name_prefix}-APP"
	launch_configuration = aws_launh_configuration.app_launch_configuration.id
	vpz_zone_identifier = [aws_subnet.COURSE_PUBLIC_SUNET.id, aws_subnet.COURSE_PRIVATE_SUNET.id]
	min_size = "2"
	max_size = "4"
	health_check_type = "EC2"
	lifecycle {
		create_before_destroy = true
	}

	tag = local.asg_default_tags
}

resource "aws_autoscalling_attachment" "asg_attachment"{
	autoscalling_group_name = aws_autocalling_group.app_asg.name
	alb_target_group_arn = aws_lb_target_group.APP_TG.arn
}
