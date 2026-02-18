terraform {
  backend "s3" {
    bucket         = "cloudtech-terraform-state-soniya"
    key            = "soniya-teams/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}