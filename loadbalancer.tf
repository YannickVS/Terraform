#Creation of the application loadbalancer



#Application load balancer
resource "aws_lb" "alb" {
  	name               = "lab6-alb"
  	internal           = false
  	load_balancer_type = "application"
  	security_groups    = [aws_security_group.LABO-6-sec-group.id]
  	subnets            = [aws_subnet.LABO6_sub1.id, aws_subnet.LABO6_sub2.id]

  	enable_deletion_protection = false

	ip_address_type = "ipv4"
}

#ALB Listener
resource "aws_lb_listener" "lab6_alb_listener" {
	load_balancer_arn = aws_lb.alb.arn
	port = 80
	protocol = "HTTP"
	default_action {
		type = "forward"
		target_group_arn = aws_lb_target_group.target_alb.arn
	}
}

#ALB Target Group
resource "aws_lb_target_group" "target_alb" {
	health_check {
		interval = 10
		path = "/"
		protocol = "HTTP"
		timeout = 5
		healthy_threshold = 5
		unhealthy_threshold = 2
	}

  	name     = "terraform-alb-target"
  	port     = 80
  	protocol = "HTTP"
  	vpc_id   = aws_vpc.VPC_LABO6.id
	target_type = "instance"
}

#Target Group EC2 1
resource "aws_lb_target_group_attachment" "TG-attachment-ec2-1" {
  	target_group_arn = aws_lb_target_group.target_alb.arn
  	target_id        = aws_instance.web.id
  	port             = 80
}

#Target Group EC2 2
resource "aws_lb_target_group_attachment" "TG-attachment-ec2-2" {
  	target_group_arn = aws_lb_target_group.target_alb.arn
  	target_id        = aws_instance.web2.id
  	port             = 80
}

#Target Group EC2 3
resource "aws_lb_target_group_attachment" "TG-attachment-ec2-3" {
  	target_group_arn = aws_lb_target_group.target_alb.arn
  	target_id        = aws_instance.web3.id
  	port             = 80
}