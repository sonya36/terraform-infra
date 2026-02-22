aws_region     = "us-east-1"
env            = "prod"
vpc_cidr       = "10.30.0.0/16"
azs            = ["us-east-1a", "us-east-1b"]
public_subnets = ["10.30.1.0/24", "10.30.2.0/24"]

# Use an Ubuntu AMI for your region (you can replace later)
ami_id        = "ami-0b6c6ebed2801a5cb"
instance_type = "t2.micro"

app_bucket_name = "myapp-prod-unique-bucket-name-12345"

tags = {
  Project = "terraform-infra"
  Owner   = "soniya"
  Env     = "prod"
}