# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = "~> 1.0"
}

provider "aws" {
  region = "us-east-1" # Change to your desired region
}


# Generate a random suffix for resource names
resource "random_string" "suffix" {
  length = 8
  special = false
  upper   = false
}
