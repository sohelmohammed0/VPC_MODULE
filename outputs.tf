output "vpc_ids" {
  description = "IDs of the created VPCs"
  value       = module.vpc.vpc_ids
}

output "public_subnet_ids" {
  description = "IDs of the public subnets in each VPC"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets in each VPC"
  value       = module.vpc.private_subnet_ids
}