variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "us-east-1" # You can set a default value here or in a terraform.tfvars file
}