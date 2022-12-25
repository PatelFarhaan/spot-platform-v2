// Spot Plane Custom Policies for Code Deploy
resource "aws_iam_policy" "client_defined_policies" {
  description = "Client Defined Policies for Application"
  name        = "${var.env}-${var.app}-client-policies-for-ec2"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : var.client_defined_policies
  })
}
