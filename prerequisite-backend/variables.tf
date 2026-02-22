variable "aws_region" { type = string }

variable "state_bucket_name" {
  type        = string
  description = "S3 bucket for terraform remote state"
}

variable "lock_table_name" {
  type        = string
  description = "DynamoDB table for terraform state locking"
}

variable "tags" {
  type    = map(string)
  default = {}
}