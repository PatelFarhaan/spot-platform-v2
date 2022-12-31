// User data for Spot and OD
data "template_file" "spotops_user_data" {
  template = <<EOF
#!/bin/bash

set -e -x
# download file from and know what needs to be deployed (webapp or database) based on env

EOF
}
