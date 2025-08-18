output "vpc_id" {
  description = "ID of the VPC"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.network.private_subnet_ids
}

output "instance_ids" {
  description = "IDs of the EC2 instances"
  value       = module.compute.instance_ids
}

output "instance_public_ips" {
  description = "Public IP addresses of the EC2 instances"
  value       = module.compute.instance_public_ips
}

output "web_urls" {
  description = "URLs to access the web servers"
  value       = [for ip in module.compute.instance_public_ips : "http://${ip}"]
}
