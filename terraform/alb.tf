# ------------------------------
#  ApplicationLoadBalancer
# ------------------------------

resource "aws_lb" "public" {
  name                       = "taskleaf-alb"
  load_balancer_type         = "application"
  idle_timeout               = 60
  internal                   = false
  enable_deletion_protection = false
  subnets = [
    aws_subnet.public_1a.id,
    aws_subnet.public_1c.id
  ]
  security_groups = [aws_security_group.alb.id]
}
output "alb_dns_name" {
  value = aws_lb.public.dns_name
}
# curl http://**** で確認

# ------------------------------
#  Listener + alb + tg
# ------------------------------

# http listener
resource "aws_lb_listener" "http" {
  load_balancer_arn  = aws_lb.public.arn
  port               = "80"
  protocol           = "HTTP"
  default_action {
    type             = "fixed-response"
    target_group_arn = aws_lb_target_group.public.arn
    fixed_response {
      content_type   = "text/plain"
      message_body   = "これは[HTTP]です"
      status_code    = "200"
    }
  }
}

# ------------------------------
#  TargetGroup
# ------------------------------

resource "aws_lb_target_group" "public" {
  name        = "taskleaf-alb-tg"
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.public.id

  health_check {
    path                = "/"
    timeout             = 5
    interval            = 30
    matcher             = 200
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
  depends_on = [aws_lb.public]
}

# ------------------------------
#  Attachment TargetGroup + ec2
# ------------------------------

resource "aws_lb_target_group_attachment" "public_1a" {
  target_group_arn = aws_lb_target_group.public.arn
  target_id        = aws_instance.ec2_1a.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "public_1c" {
  target_group_arn = aws_lb_target_group.public.arn
  target_id        = aws_instance.ec2_1c.id
  port             = 80
}

# ------------------------------
#  SecurityGroup
# ------------------------------

resource "aws_security_group" "alb" {
  name        = "taskleaf-alb-sg"
  description = "Allow http https"
  vpc_id      = aws_vpc.public.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
