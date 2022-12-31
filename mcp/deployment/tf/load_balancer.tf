// creating a Load Balancer
resource "aws_lb" "load_balancer" {
  internal                   = false
  ip_address_type            = "ipv4"
  load_balancer_type         = "application"
  enable_deletion_protection = false
  subnets                    = [
    "subnet-00559225548afa7d4", "subnet-078d8ce666dcbd6ba", "subnet-0c73f4d65aef7adf4",
    "subnet-0e3597bed0f180f79", "subnet-0d75bad323fdb2481", "subnet-0c26209bd1cfeeac6"
  ]
  name                       = "jenkins-load-balancer"
  security_groups            = [aws_security_group.lb_security_group.id]

  tags = {
    Name = "jenkins-load-balancer"
  }
}