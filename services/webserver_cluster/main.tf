
resource "aws_security_group" "sg" {
  name        = "${local.environment}-SecurityGroup"
  description = "Allow TLS & SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = local.http_protocol
      cidr_blocks = local.any_cidr_block
    }
  }

  egress {
    from_port   = local.any_port
    to_port     = local.any_port
    protocol    = local.any_protocol
    cidr_blocks = local.any_cidr_block
  }

  tags = merge(local.environment == "prod" ? var.tags_prod : var.tags, { Name = "${local.environment}-SecurityGroup" })
}

resource "aws_launch_configuration" "launch_configuration" {
  name_prefix     = "lc-"
  image_id        = data.aws_ami.latest_amazon_linux_ami.id
  instance_type   = local.environment == "prod" ? var.instance_type_prod : var.instance_type
  security_groups = [aws_security_group.sg.id]
  user_data       = data.template_file.user_data.rendered
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "autoscaling_group" {
  name                      = "${local.environment}-ASG-${aws_launch_configuration.launch_configuration.name}"
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  target_group_arns         = [aws_lb_target_group.tgs.arn]
  launch_configuration      = aws_launch_configuration.launch_configuration.name
  vpc_zone_identifier       = data.aws_subnet_ids.default.ids

  dynamic "tag" {
    for_each = {
      Name = "${local.environment}-server created by ASG"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "lb" {
  name               = "${local.environment}-LoadBalancer"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.default.ids
  security_groups    = [aws_security_group.sg.id]
  tags               = merge(local.environment == "prod" ? var.tags_prod : var.tags, { Name = "${local.environment}-LoadBalancer" })
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = local.http_port
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_listener_rule" "http_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tgs.arn
  }
}

resource "aws_lb_target_group" "tgs" {
  name     = "${local.environment}-TargetGroup"
  port     = local.http_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/index.html"
    protocol            = "HTTP"
    matcher             = "200"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 10
  }

  tags = merge(local.environment == "prod" ? var.tags_prod : var.tags, { Name = "${local.environment} Target Group" })
}
