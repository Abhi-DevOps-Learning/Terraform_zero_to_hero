terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

# Create a EC2
resource "aws_instance" "app_server" {
  
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "Terraform_Demo"
  }
}
