variable "aws_region" {
  description = "AWS region to create backend resources in"
  type        = string
  default     = "us-east-1"
}

variable "state_bucket_name" {
  description = "Globally-unique S3 bucket name for Terraform state"
  type        = string
  default     = "cloudtech-terraform-state-664418970145"
}

variable "lock_table_name" {
  description = "DynamoDB table name for Terraform state locking"
  type        = string
  default     = "terraform-locks"
}

variable "tags" {
  description = "Tags to apply to backend resources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Purpose   = "terraform-backend"
  }
}