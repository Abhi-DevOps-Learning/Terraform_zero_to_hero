# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE AN S3 BUCKET AND DYNAMODB TABLE TO USE AS A TERRAFORM BACKEND
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# This module is now only being tested with Terraform 1.1.x. However, to make upgrading easier, we are setting 1.0.0 as the minimum version.
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 1.0.0"
}

# ------------------------------------------------------------------------------
# CONFIGURE OUR AWS CONNECTION(Terraform needs to know which cloud provider you are using and how to connect to it, as we don't provide region it will take your aws account region by default)
# ------------------------------------------------------------------------------

provider "aws" {}

# ------------------------------------------------------------------------------
# CREATE THE S3 BUCKET( Retrieves information about the currently authenticated AWS account, such as the account ID,The account ID is used to ensure that the S3 bucket name is globally unique.)
# ------------------------------------------------------------------------------

data "aws_caller_identity" "current" {}

# ------------------------------------------------------
# Creates a local variable to store the AWS account ID.
# ------------------------------------------------------

locals {
  account_id = data.aws_caller_identity.current.account_id
}

resource "aws_s3_bucket" "terraform_state" {
  # With account id, this S3 bucket names can be *globally* unique.
  bucket = "${local.account_id}-terraform-states"

  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  }

  # Enable server-side encryption by default
  # Prevents any public access to the S3 bucket.
  # Ensures that the state files stored in the bucket are not publicly accessible, which is crucial for security.

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# -------------------------------------------------------------------------------------------------------------------------------------------------------------
# CREATE THE DYNAMODB TABLE
# Creates a DynamoDB table named terraform-lock to manage state locking.
# Terraform uses this table to lock the state file, ensuring that only one process can modify it at a time, preventing race conditions in a team environment.
# --------------------------------------------------------------------------------------------------------------------------------------------------------------

resource "aws_dynamodb_table" "terraform_lock" {
  name         = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
