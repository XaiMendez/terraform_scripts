# ec2 instance
# public ip
# instance profile
# key pairs
# s3 bucket

data "aws_ami" "windows2016" {
	most_recent = true
	filter {
    name   = "name"
    values = ["Windows_Server-2016-English-Full-HyperV-*"]
  }
	filter{
		name = "virtualization-type"
		values = ["hvm"]
	}

	owners = ["801119661308"] # amazon

}

resource "aws_instance" "jumpbox" {
	associate_public_ip_address = true
	disable_api_termination = false
	ami = data.aws_ami.windows2016.id
	instance_type = var.instance_type
	#user_data = ""
	key_name = aws_key_pair.generated_key.key_name
	iam_instance_profile = aws_iam_instance_profile.app_instance_profile.name
	vpc_security_group_ids = [aws_security_group.APP_SG.id]
	subnet_id = aws_subnet.DEV_01_PUBLIC_SUBNET.id

	tags = merge({
		"Name": "${local.name_prefix}-JumpBox"
	},
	local.default_tags,
	)
}
