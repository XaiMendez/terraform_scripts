# iam access

resource "aws_iam_group" "iam_admin" {
	name = "iam_admin"
}


resource "aws_iam_policy_attachment" "admin-attachment" {
	name = "admin-attachment"
	groups = ["aws_iam_group.iam_admin.name"]
	policy_arn = "arn:aws:iam"
}

resource "aws_iam_user" "admin_user_1" {
	name = "admin_user_1"
}

resource "aws_iam_user" "admin_user_2" {
	name = "admin_user_2"
}

resource "aws_iam_group_membership" "gm_admin_users" {
	name = "gm_admin_users"
	users = ["${aws_iam_user.admin_user_1.name}", "${aws_iam_user.admin_user_2.name}"]

	group = "${aws_iam_group.iam_admin.name}"
}


resource "aws_iam_access_key" "admin_user_1_access" {
	user = "${aws_iam_user.admin_user_1.name}""


resource "aws_iam_access_key" "admin_user_2_access" {
	user = "${aws_iam_user.admin_user_2.name}""
}

#secret key
output "admin_user_1_access_key" {
	value = "${aws_iam_access_key.admin_user_1_access.id}"
}

output "admin_user_1_secret_key" {
	value = "${aws_iam_access_key.admin_user_1_access.secret}"
}

output "admin_user_2_access_key" {
	value = "${aws_iam_access_key.admin_user_2_access.id}"
}

output "admin_user_2_secret_key" {
	value = "${aws_iam_access_key.admin_user_2_access.secret}"
}
