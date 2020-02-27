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


