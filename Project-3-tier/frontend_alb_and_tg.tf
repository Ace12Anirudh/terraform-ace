resource "aws_lb_target_group" "front_end"{    
    name     = "frontend-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = aws_vpc.vpc.id
    depends_on = [ aws_vpc.vpc ]
}

resource "aws_lb" "front_end" {
  name = "frontend-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb-frontend-sg.id]
  subnets = [aws_subnet.public-1.id, aws_subnet.public-2.id]
 
  tags = {
    Name = "ALB-Frontend"
  }
  depends_on = [ aws_lb_target_group.front_end ]
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.front_end.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.front_end.arn
  }
  depends_on = [ aws_lb_target_group.front_end ]
}