terraform {
  backend "s3" {
    bucket         = "cloudtech-terraform-state-soniya-789"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}