# type: application
# intern
# target group
# health check

#load_balancers.tf

resource "aws_lb" "app_alb" {
	name = "${local.name_prefix}-app-ALB"
	internal = true
	load_balancer_type = "application"
	idle_timeout = 600
	security_groups = [aws_security_group.APP_ALB_SG.id]
	subnet = [aws_subnet.COURSE_PUBLIC_SUBNET.id, aws_subnet.COURSE_PRIVATE_SUBNET.id]
	enable_deletion_protection = false

	tags = merge({
		"Name" = "${local.name_prefix}-app-ALB"
	},
		local.default_tags,
	)
}

resource "aws_lb_target_group" "APP_TG" {
	name = "${local.prefix_name}-APP-TG"

	port = "80"
	protocol = "HTTP"
	vpc_id = aws_vpc.COURSE_VPC.id
	target_type = "instance"

		tags = merge({
		"Name" = "${local.name_prefix}-APP-LB-TG"
	},
		local.default_tags,
	)

	lifecycle{
		create_before_destroy = true
		ignore_changes = [name]
	}

	health_check {
		interval = 30
		healthy = 2
		unhealthy_thresholds = 2
		timeout = 5
		matcher = "200"
	}
}


resource "aws_lb_listener" "APP_http_listener" {
	load_balance_arn = aws_lb.app_alb.arn
	port = 80
	protocol = "HTTP"

	default_action{
		type = "forward"
		target_group_arn = aws_lb_target_group.APP_TG.arn
	}
}
