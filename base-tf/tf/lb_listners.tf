// Public listener on port 80
resource "aws_lb_listener" "port_80" {
  port              = 80
  protocol          = "HTTP"
  load_balancer_arn = aws_lb.global_apps_lb.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  tags = local.config_data.tags
}


// Secure listener on port 443
resource "aws_lb_listener" "port_443" {
  port              = 443
  protocol          = "HTTPS"
  load_balancer_arn = aws_lb.global_apps_lb.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.default_global_certs.arn

  depends_on = [
    aws_route53_record.global_acm_records,
    aws_acm_certificate.default_global_certs
  ]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  tags = local.config_data.tags
}


// Secure listener on port 27017
resource "aws_lb_listener" "port_27017" {
  port              = 27017
  protocol          = "HTTPS"
  load_balancer_arn = aws_lb.global_apps_lb.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.default_global_certs.arn

  depends_on = [
    aws_route53_record.global_acm_records,
    aws_acm_certificate.default_global_certs
  ]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  tags = local.config_data.tags
}


// Secure listener on port 3306
resource "aws_lb_listener" "port_3306" {
  port              = 3306
  protocol          = "HTTPS"
  load_balancer_arn = aws_lb.global_apps_lb.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.default_global_certs.arn

  depends_on = [
    aws_route53_record.global_acm_records,
    aws_acm_certificate.default_global_certs
  ]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  tags = local.config_data.tags
}


// Secure listener on port 5432
resource "aws_lb_listener" "port_5432" {
  port              = 5432
  protocol          = "HTTPS"
  load_balancer_arn = aws_lb.global_apps_lb.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.default_global_certs.arn

  depends_on = [
    aws_route53_record.global_acm_records,
    aws_acm_certificate.default_global_certs
  ]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  tags = local.config_data.tags
}


// Secure listener on port 6379
resource "aws_lb_listener" "port_6379" {
  port              = 6379
  protocol          = "HTTPS"
  load_balancer_arn = aws_lb.global_apps_lb.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.default_global_certs.arn

  depends_on = [
    aws_route53_record.global_acm_records,
    aws_acm_certificate.default_global_certs
  ]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  tags = local.config_data.tags
}
