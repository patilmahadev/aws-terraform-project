resource "aws_security_group" "remotex-sg-elb" {
  name   = "remotex-sg-elb"
  vpc_id = aws_vpc.remotex-vpc.id

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "remotex-sg-elb"
  }
}

resource "aws_elb" "remotex-elb" {
  name                = "remotex-elb"
  subnets             = [aws_subnet.remotex-pub-sub.id]
  security_groups     = [aws_security_group.remotex-sg-elb.id]
  instances           = aws_instance.remotex-web-instance.*.id
  connection_draining = true

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    interval            = 30
    target              = "HTTP:80/index.html"
    timeout             = 3
    unhealthy_threshold = 2
  }

  tags = {
    Name = "remotex-elb"
  }
}