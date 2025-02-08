aws_region = "us-east-1"

vpc_names = ["vpc1", "vpc2"]

base_cidr = "10.0.0.0/16"

availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

public_subnet_count  = 1
private_subnet_count = 1

tags = {
  Environment = "Development"
  Project     = "VPC-Module"
}