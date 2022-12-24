// Defining the provider
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}


// Reading data variables from app_config.json file
locals {
  config_data = jsondecode(file("./../config.json"))
}
