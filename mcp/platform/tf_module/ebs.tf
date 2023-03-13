// Creating a multi attach EBS for Terraform
resource "aws_ebs_volume" "ebs_multi_attach" {
  iops                 = 100
  multi_attach_enabled = true
  type                 = "io2"
  availability_zone    = var.availability_zone
  size                 = var.ebs_multi_attach_volume_size

  tags = merge(
    var.tags,
    {
      "Name" : "${var.tags["Name"]}-multiattach"
    }
  )
}
