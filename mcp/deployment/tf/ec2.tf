// Defining the ec2 instance
resource "aws_instance" "ec2_instance" {
  ami             = "ami-09e67e426f25ce0d7"
  instance_type   = "t2.micro"
  tenancy         = "default"
  key_name        = "bioos-development"
  security_groups = [aws_security_group.jenkins_sg.name]
  user_data            = base64encode(data.template_file.cloud_init_script.rendered)

  monitoring                           = false
  instance_initiated_shutdown_behavior = "stop"

  tags = {
    "Name" : "jenkins-mcp-tf"
  }

#  connection {
#    port        = 22
#    agent       = true
#    timeout     = "1m"
#    type        = "ssh"
#    user        = "ubuntu"
#    host        = aws_instance.ec2_instance.public_ip
#    private_key = file("${path.module}/farhaan.pem")
#  }
}
