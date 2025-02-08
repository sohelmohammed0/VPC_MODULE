output "vpc_ids" {
  description = "IDs of the created VPCs"
  value       = { for vpc, obj in aws_vpc.main : vpc => obj.id }
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [for subnet in flatten([for k, v in aws_subnet.public : v]) : subnet.id]
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = [for subnet in flatten([for k, v in aws_subnet.private : v]) : subnet.id]
}