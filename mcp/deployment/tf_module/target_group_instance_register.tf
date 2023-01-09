// register instance for target group
resource "aws_lb_target_group_attachment" "register_instance_port_80" {
  port             = 80
  target_id        = aws_instance.ec2_instance.id
  target_group_arn = aws_lb_target_group.target_group_port_80.arn
}


// register instance for target group
resource "aws_lb_target_group_attachment" "register_instance_port_8200" {
  port             = 8200
  target_id        = aws_instance.ec2_instance.id
  target_group_arn = aws_lb_target_group.target_group_port_8200.arn
}
