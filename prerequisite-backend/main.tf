terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}


# S3 bucket for Terraform state

resource "aws_s3_bucket" "soniya_bucket" {
  bucket = var.state_bucket_name

  tags = var.tags
}

# Block all public access 
resource "aws_s3_bucket_public_access_block" "soniya_bucket" {
  bucket                  = aws_s3_bucket.soniya_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning
resource "aws_s3_bucket_versioning" "soniya_bucket" {
  bucket = aws_s3_bucket.soniya_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable default encryption (SSE-S3 / AES256)
resource "aws_s3_bucket_server_side_encryption_configuration" "soniya_bucket" {
  bucket = aws_s3_bucket.soniya_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


# DynamoDB table for state lock

resource "aws_dynamodb_table" "tf_locks" {
  name         = var.lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = var.tags
}