// register instance for target group
resource "aws_lb_target_group_attachment" "register_instance_ports" {
  count = length(var.dns_names)

  port             = var.dns_names[count.index]["port"]
  target_id        = aws_instance.ec2_instance.id
  target_group_arn = aws_lb_target_group.target_group_ports[count.index].arn
}
