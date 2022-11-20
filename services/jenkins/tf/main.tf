// Defining the provider
terraform {
  required_version = "~> 1.3.2"

  backend "s3" {
    encrypt        = true
    region         = "us-east-1"
    bucket         = "bios-tfstates-bucket"
    key            = "jenkins/terraform.tfstate"
    dynamodb_table = "mcp-terraform-state-lock"
  }
}


// Reading data variables from app_config.json file
locals {
  config_data = jsondecode(file("./../config.json"))
}
