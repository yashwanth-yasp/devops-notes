# Project Configuration
project_name = "my-web-app"
environment  = "dev"
owner        = "your-name"

# AWS Configuration
aws_region         = "us-west-2"
availability_zones = ["us-west-2a", "us-west-2b"]

# Network Configuration
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]

# Compute Configuration
instance_type     = "t3.micro"
instance_count    = 2
key_pair_name     = "your-key-pair"  # Replace with your key pair name
enable_monitoring = false
root_volume_size  = 20